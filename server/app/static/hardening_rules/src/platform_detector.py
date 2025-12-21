#!/usr/bin/env python3
"""Platform detection utility for multi-platform security automation framework.

This module provides functionality to detect the current operating system platform,
distribution, and variant. It's used by other tools to automatically determine which
set of security rules to apply.
"""
from __future__ import annotations

import json
import platform
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Optional


@dataclass
class PlatformInfo:
    """Holds detected platform information."""
    platform: str  # linux, windows, android
    distribution: str  # ubuntu, debian, rhel, windows11, etc.
    variant: str  # desktop, server
    version: str  # 22.04, 11, 2022, etc.
    architecture: str  # x86_64, aarch64, arm64, etc.

    def get_rules_path(self, base_path: Path = Path("platforms")) -> Path:
        """Return the path to rules directory for this platform."""
        if self.platform == "linux":
            return base_path / "linux" / self.distribution / self.variant / "rules"
        elif self.platform == "windows":
            if self.variant == "server":
                return base_path / "windows" / "server" / self.version / "rules"
            else:
                version_short = "win11" if "11" in self.version else "win10"
                return base_path / "windows" / "desktop" / version_short / "rules"
        elif self.platform == "android":
            return base_path / "android" / "rules"
        else:
            raise ValueError(f"Unknown platform: {self.platform}")

    def get_metadata_path(self, base_path: Path = Path("platforms")) -> Path:
        """Return the path to metadata.json for this platform."""
        rules_path = self.get_rules_path(base_path)
        return rules_path.parent / "metadata.json"

    def to_dict(self) -> dict:
        """Convert to dictionary representation."""
        return {
            "platform": self.platform,
            "distribution": self.distribution,
            "variant": self.variant,
            "version": self.version,
            "architecture": self.architecture,
        }


def detect_linux_distribution() -> tuple[str, str, str]:
    """Detect Linux distribution and variant.

    Returns:
        Tuple of (distribution, variant, version)
    """
    try:
        # Try using /etc/os-release (modern standard)
        with open("/etc/os-release") as f:
            os_release = {}
            for line in f:
                if "=" in line:
                    key, value = line.rstrip().split("=", 1)
                    os_release[key] = value.strip('"')

        distro_id = os_release.get("ID", "unknown").lower()
        version = os_release.get("VERSION_ID", "unknown")

        # Detect if server or desktop
        variant = "server"
        variant_id = os_release.get("VARIANT_ID", "").lower()
        if "desktop" in variant_id or "workstation" in variant_id:
            variant = "desktop"
        elif distro_id in ["ubuntu", "debian"]:
            # Check if desktop environment is installed
            try:
                subprocess.run(
                    ["which", "gnome-shell"],
                    capture_output=True,
                    check=True
                )
                variant = "desktop"
            except (subprocess.CalledProcessError, FileNotFoundError):
                variant = "server"

        return distro_id, variant, version

    except FileNotFoundError:
        # Fallback for older systems
        try:
            result = subprocess.run(
                ["lsb_release", "-is"],
                capture_output=True,
                text=True,
                check=True
            )
            distro = result.stdout.strip().lower()

            version_result = subprocess.run(
                ["lsb_release", "-rs"],
                capture_output=True,
                text=True,
                check=True
            )
            version = version_result.stdout.strip()

            return distro, "server", version
        except (subprocess.CalledProcessError, FileNotFoundError):
            return "unknown", "unknown", "unknown"


def detect_windows_version() -> tuple[str, str]:
    """Detect Windows version and variant.

    Returns:
        Tuple of (variant, version)
    """
    win_version = platform.version()
    win_release = platform.release()

    # Detect Server vs Desktop
    try:
        result = subprocess.run(
            ["powershell", "-Command", "(Get-WmiObject Win32_OperatingSystem).Caption"],
            capture_output=True,
            text=True,
            check=True
        )
        caption = result.stdout.strip()

        if "Server" in caption:
            # Extract server version (2019, 2022, etc.)
            if "2022" in caption:
                return "server", "2022"
            elif "2019" in caption:
                return "server", "2019"
            else:
                return "server", "unknown"
        else:
            # Desktop version
            if win_release == "11" or "11" in caption:
                return "desktop", "11"
            elif win_release == "10" or "10" in caption:
                return "desktop", "10"
            else:
                return "desktop", win_release
    except (subprocess.CalledProcessError, FileNotFoundError):
        # Fallback
        if "Server" in win_version:
            return "server", "unknown"
        else:
            return "desktop", win_release


def detect_platform() -> PlatformInfo:
    """Detect the current platform and return detailed information.

    Returns:
        PlatformInfo object with detected platform details
    """
    system = platform.system().lower()
    arch = platform.machine()

    if system == "linux":
        # Check if Android
        try:
            with open("/system/build.prop") as f:
                # Android system detected
                for line in f:
                    if line.startswith("ro.build.version.release"):
                        version = line.split("=")[1].strip()
                        return PlatformInfo(
                            platform="android",
                            distribution="android",
                            variant="mobile",
                            version=version,
                            architecture=arch
                        )
        except FileNotFoundError:
            pass

        # Regular Linux
        distro, variant, version = detect_linux_distribution()
        return PlatformInfo(
            platform="linux",
            distribution=distro,
            variant=variant,
            version=version,
            architecture=arch
        )

    elif system == "windows":
        variant, version = detect_windows_version()
        return PlatformInfo(
            platform="windows",
            distribution=f"windows{version}" if variant == "desktop" else "windows_server",
            variant=variant,
            version=version,
            architecture=arch
        )

    else:
        raise RuntimeError(f"Unsupported platform: {system}")


def load_metadata(metadata_path: Path) -> dict:
    """Load platform metadata from JSON file."""
    if not metadata_path.exists():
        raise FileNotFoundError(f"Metadata file not found: {metadata_path}")

    with open(metadata_path, "r", encoding="utf-8") as f:
        return json.load(f)


def list_available_platforms(base_path: Path = Path("platforms")) -> list[dict]:
    """List all available platforms with their metadata.

    Returns:
        List of dictionaries containing platform information
    """
    platforms = []

    # Search for all metadata.json files, but exclude rule-level metadata
    for metadata_file in base_path.rglob("metadata.json"):
        # Skip metadata files inside rules directories
        if "rules" in metadata_file.parts:
            continue

        try:
            metadata = load_metadata(metadata_file)
            # Validate it's a platform metadata (has 'platform' key)
            if 'platform' in metadata:
                metadata["path"] = str(metadata_file.parent)
                platforms.append(metadata)
        except Exception as e:
            print(f"Warning: Could not load {metadata_file}: {e}")

    return platforms


def main():
    """CLI entry point for platform detection."""
    import argparse

    parser = argparse.ArgumentParser(
        description="Detect current platform or list available platforms"
    )
    parser.add_argument(
        "--list",
        action="store_true",
        help="List all available platforms"
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output in JSON format"
    )
    parser.add_argument(
        "--rules-path",
        action="store_true",
        help="Show path to rules directory"
    )

    args = parser.parse_args()

    if args.list:
        platforms = list_available_platforms()
        if args.json:
            print(json.dumps(platforms, indent=2))
        else:
            print(f"\nAvailable Platforms ({len(platforms)}):")
            print("-" * 80)
            for p in platforms:
                print(f"  {p['platform']:10} | {p['distribution']:15} | "
                      f"{p['variant']:10} | {p.get('versions', ['N/A'])[0]}")
    else:
        platform_info = detect_platform()

        if args.json:
            print(json.dumps(platform_info.to_dict(), indent=2))
        elif args.rules_path:
            print(platform_info.get_rules_path())
        else:
            print("\nDetected Platform:")
            print("-" * 80)
            print(f"  Platform:     {platform_info.platform}")
            print(f"  Distribution: {platform_info.distribution}")
            print(f"  Variant:      {platform_info.variant}")
            print(f"  Version:      {platform_info.version}")
            print(f"  Architecture: {platform_info.architecture}")
            print(f"\n  Rules Path:   {platform_info.get_rules_path()}")


if __name__ == "__main__":
    main()
