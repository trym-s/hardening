#!/usr/bin/env python3
"""Generate a registry JSON from the rules directory.

The registry captures the rule ID, title, section, and the locations of the
corresponding audit and remediation scripts. It derives metadata from the
folder hierarchy beneath ``rules/`` where each rule directory contains both an
``audit.sh`` file and a remediation script whose filename contains
``remediation``.

This script automatically scans all Section directories (Section 1 through Section 4)
and generates the index.json file with all discovered rules.
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Iterable, List, Tuple


SCRIPT_DIR = Path(__file__).parent.resolve()
HARDENING_RULES_DIR = SCRIPT_DIR.parent.parent

DEFAULT_RULES_DIR = HARDENING_RULES_DIR / "src/rules"
DEFAULT_OUTPUT_PATH = HARDENING_RULES_DIR / "index.json"

RuleEntry = dict


def parse_rule_directory(rule_dir: Path, section: str, base_dir: Path) -> RuleEntry | None:
    """Return a registry entry if audit/remediation scripts exist.
    
    Supports both naming conventions:
    - Standard: audit.sh and remediation.sh
    - Custom: *_audit.sh and *_remediation.sh
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
            return None
    
    # Try to find remediation script (*remediation*.sh or remediation.sh)
    remediation_candidates = sorted(rule_dir.glob("*remediation*.sh"))
    if not remediation_candidates:
        return None

    remediation_path = remediation_candidates[0]
    rule_name = rule_dir.name

    if " " in rule_name:
        rule_id, title = rule_name.split(" ", 1)
    else:
        rule_id, title = rule_name, rule_name

    return {
        "id": rule_id,
        "title": title,
        "section": section,
        "os": "ubuntu",
        "description": f"Placeholder description for rule {rule_id}. Details about the audit and remediation steps are included in the scripts.",
        "audit": str(audit_path.resolve().relative_to(base_dir).as_posix()),
        "remediation": str(remediation_path.resolve().relative_to(base_dir).as_posix()),
    }


def natural_key(rule_id: str) -> Tuple:
    """Produce a key that keeps numeric rule fragments in order."""
    fragments = re.split(r"(\d+)", rule_id)
    key_parts: List[int | str] = []
    for fragment in fragments:
        if fragment.isdigit():
            key_parts.append(int(fragment))
        elif fragment:
            key_parts.append(fragment)
    return tuple(key_parts)


def get_full_section_name(short_name: str) -> str:
    """Convert short section name (S1) to full name (Section 1 Initial Setup)."""
    section_map = {
        "s1": "Section 1 Initial Setup",
        "s2": "Section 2 Services",
        "s3": "Section 3 Network",
        "s4": "Section 4 Host Based Firewall",
    }
    return section_map.get(short_name.lower(), short_name)


def discover_rules(rules_dir: Path, base_dir: Path) -> List[RuleEntry]:
    """Discover all rules in Section directories and return sorted registry."""
    registry: List[RuleEntry] = []
    
    # Scan all Section directories (now s1, s2, s3, s4)
    for section_dir in sorted(rules_dir.iterdir()):
        if not section_dir.is_dir():
            continue
        
        # Process both old format (Section X) and new format (sX)
        if not section_dir.name.lower().startswith(("section", "s")):
            continue
        
        # Get full section name for index.json
        full_section_name = get_full_section_name(section_dir.name)
        
        print(f"Scanning {section_dir.name} ({full_section_name})...")
        
        # Recursively find all directories that contain audit.sh
        for rule_dir in section_dir.rglob("*"):
            if not rule_dir.is_dir():
                continue
            entry = parse_rule_directory(rule_dir, full_section_name, base_dir)
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
        "--rules-dir", default=DEFAULT_RULES_DIR, type=Path, help="Root directory containing rule folders"
    )
    parser.add_argument(
        "--output", default=DEFAULT_OUTPUT_PATH, type=Path, help="Output registry path"
    )
    return parser.parse_args()


def main() -> None:
    """Main entry point for the script."""
    args = parse_args()
    
    # Base directory for making paths relative
    base_dir = args.output.parent.resolve()
    
    print(f"Discovering rules in {args.rules_dir}...")
    registry = discover_rules(args.rules_dir, base_dir)
    
    print(f"\nFound {len(registry)} rules total")
    print(f"Writing to {args.output}...")
    write_registry(registry, args.output)
    
    print(f"\n[OK] Successfully generated {args.output}")
    print(f"[OK] Total rules: {len(registry)}")


if __name__ == "__main__":
    main()