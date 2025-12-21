import argparse
import json
import re
from pathlib import Path
from typing import Iterable, List, Tuple, Optional


RuleEntry = dict

SCRIPT_DIR = Path(__file__).parent
PLATFORMS_BASE_DIR = SCRIPT_DIR / "platforms"

def parse_rule_directory(rule_dir: Path, section: str) -> RuleEntry | None:
    """Return a registry entry if audit script exists.
    
    Supports both naming conventions:
    - Standard: audit.sh and remediation.sh
    - Custom: *_audit.sh and *_remediation.sh
    
    Rules with audit.sh but no remediation.sh will have remediation: null
    (audit-only rules).
    """
    # Try to find audit script (audit.sh or *_audit.sh)
    audit_path = rule_dir / "audit.sh"
    if not audit_path.exists():
        # Try pattern-based search for *_audit.sh files
        audit_candidates = sorted(rule_dir.glob("*_audit.sh"))
        if not audit_candidates:
            audit_candidates = sorted(rule_dir.glob("*audit*.sh"))
        if audit_candidates:
            audit_path = audit_candidates[0]
        else:
            return None  # No audit script = not a valid rule
    
    # Try to find remediation script (*remediation*.sh or remediation.sh)
    remediation_candidates = sorted(rule_dir.glob("*remediation*.sh"))
    remediation_path = remediation_candidates[0] if remediation_candidates else None

    rule_name = rule_dir.name

    if " " in rule_name:
        rule_id, title = rule_name.split(" ", 1)
    else:
        rule_id, title = rule_name, rule_name

    return {
        "id": rule_id,
        "title": title,
        "section": section,
        "audit": str(audit_path.as_posix()),
        "remediation": str(remediation_path.as_posix()) if remediation_path else None,
    }


def natural_key(rule_id: str) -> Tuple:
    """Produce a key that keeps numeric rule fragments in order."""
    fragments = re.split(r"(\d+)", rule_id)
    key_parts: List[Tuple[int, int | str]] = []
    for fragment in fragments:
        if fragment.isdigit():
            # Use (0, int) for numbers so they sort before strings
            key_parts.append((0, int(fragment)))
        elif fragment:
            # Use (1, str) for strings
            key_parts.append((1, fragment))
    return tuple(key_parts)


def get_full_section_name(short_name: str) -> str:
    """Convert short section name (S1) to full name (Section 1 Initial Setup)."""
    section_map = {
        "S1": "Section 1 Initial Setup",
        "S2": "Section 2 Services",
        "S3": "Section 3 Network",
        "S4": "Section 4 Host Based Firewall",
        "S5": "Section 5 Access Control",
    }
    return section_map.get(short_name, short_name)


def discover_rules(base_path: Path) -> List[RuleEntry]:
    """Discover all rules in Section directories and return sorted registry."""
    registry: List[RuleEntry] = []
    
    # Scan all Section directories (now S1, S2, S3, S4)
    for section_dir in sorted(base_path.iterdir()):
        if not section_dir.is_dir():
            continue
        
        # Process both old format (Section X) and new format (SX)
        if not (section_dir.name.startswith("Section") or section_dir.name.startswith("S")):
            continue
        
        # Get full section name for index.json
        full_section_name = get_full_section_name(section_dir.name)
        
        print(f"Scanning {section_dir.name} ({full_section_name})...")
        
        # Recursively find all directories that contain audit.sh
        for rule_dir in section_dir.rglob("*"):
            if not rule_dir.is_dir():
                continue
            entry = parse_rule_directory(rule_dir, full_section_name)
            if entry:
                registry.append(entry)
    
    # Sort by rule ID using natural ordering
    registry.sort(key=lambda entry: natural_key(entry["id"]))
    return registry


def write_registry(registry: Iterable[RuleEntry], output_path: Path) -> None:
    """Write the registry to JSON file."""
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8") as handle:
        json.dump(list(registry), handle, indent=2, ensure_ascii=False)
        handle.write("\n")


def parse_args() -> argparse.Namespace:
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description="Generate rule registry JSON")
    parser.add_argument(
        "--rules-dir", type=Path, help="Root directory containing rule folders (legacy mode)"
    )
    parser.add_argument(
        "--platform", type=str, help="Platform identifier (e.g., linux/ubuntu/server)"
    )
    parser.add_argument(
        "--output", type=Path, help="Output registry path"
    )
    parser.add_argument(
        "--auto-detect", action="store_true", help="Auto-detect current platform"
    )
    parser.add_argument(
        "--all-platforms", action="store_true", help="Generate registry for all platforms"
    )
    return parser.parse_args()


def process_platform(platform_path: Path) -> None:
    """Process a single platform and generate its registry."""
    rules_dir = platform_path / "rules"
    if not rules_dir.exists():
        print(f"Warning: Rules directory not found: {rules_dir}")
        return

    output_path = rules_dir / "index.json"

    print(f"\nProcessing platform: {platform_path}")
    print(f"Discovering rules in {rules_dir}...")
    registry = discover_rules(rules_dir)

    print(f"Found {len(registry)} rules")

    if len(registry) > 0:
        print(f"Writing to {output_path}...")
        write_registry(registry, output_path)
        print(f"[OK] Successfully generated {output_path}")
    else:
        print(f"[SKIP] No rules found in {rules_dir}")


def main() -> None:
    """Main entry point for the script."""
    args = parse_args()

    # Legacy mode: use --rules-dir (backward compatibility)
    if args.rules_dir:
        output = args.output or (args.rules_dir / "index.json")
        print(f"[LEGACY MODE] Discovering rules in {args.rules_dir}...")
        registry = discover_rules(args.rules_dir)

        print(f"\nFound {len(registry)} rules total")
        print(f"Writing to {output}...")
        write_registry(registry, output)

        print(f"\n[OK] Successfully generated {output}")
        print(f"[OK] Total rules: {len(registry)}")
        return

    # All platforms mode
    if args.all_platforms:
        if not PLATFORMS_BASE_DIR.exists():
            print(f"Error: Platforms base directory not found: {PLATFORMS_BASE_DIR}")
            return

        print("[ALL PLATFORMS MODE] Scanning all platforms...")

        # Find all platform directories with metadata.json
        for metadata_file in PLATFORMS_BASE_DIR.rglob("metadata.json"):
            platform_path = metadata_file.parent
            process_platform(platform_path)

        print("\n[OK] All platforms processed")
        return

    # Auto-detect mode
    if args.auto_detect:
        try:
            from platform_detector import detect_platform

            platform_info = detect_platform()
            # Need to construct the full path to the detected platform directory
            detected_platform_path = PLATFORMS_BASE_DIR / Path(platform_info.get_rules_path()).parent.relative_to(SCRIPT_DIR / "platforms")


            print(f"[AUTO-DETECT MODE]")
            print(f"Detected: {platform_info.platform} / {platform_info.distribution} / {platform_info.variant}")

            process_platform(detected_platform_path)
            return
        except ImportError:
            print("Error: platform_detector module not found")
            return
        except Exception as e:
            print(f"Error: Could not auto-detect platform: {e}")
            return

    # Specific platform mode
    if args.platform:
        # Construct the full path to the specific platform directory
        platform_path = PLATFORMS_BASE_DIR / args.platform
        if not platform_path.exists():
            print(f"Error: Platform path not found: {platform_path}")
            return

        process_platform(platform_path)
        return

    # Default: process legacy Rules directory if it exists
    legacy_rules = Path("Rules")
    if legacy_rules.exists():
        output = args.output or (legacy_rules / "index.json")
        print(f"[DEFAULT MODE] Using legacy Rules directory")
        print(f"Discovering rules in {legacy_rules}...")
        registry = discover_rules(legacy_rules)

        print(f"\nFound {len(registry)} rules total")
        print(f"Writing to {output}...")
        write_registry(registry, output)

        print(f"\n[OK] Successfully generated {output}")
        print(f"[OK] Total rules: {len(registry)}")
    else:
        print("Error: Please specify --rules-dir, --platform, --auto-detect, or --all-platforms")
        print("Run with --help for usage information")


if __name__ == "__main__":
    main()
