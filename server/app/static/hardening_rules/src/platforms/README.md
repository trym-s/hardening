# Multi-Platform Security Hardening Framework

This directory contains platform-specific CIS Benchmark security rules organized by operating system and variant.

## Directory Structure

```
platforms/
├── linux/          # Linux distributions
├── windows/        # Windows operating systems
└── android/        # Android devices
```

## Platform Organization

Each platform is organized as follows:

```
platforms/<platform>/<distribution>/<variant>/
├── rules/          # Security rules (S1-S7 sections)
│   ├── S1/        # Section 1
│   ├── S2/        # Section 2
│   └── ...
│   └── index.json # Auto-generated rule registry
└── metadata.json   # Platform metadata
```

## Working with Platforms

### Auto-detect Your Platform

```bash
python3 ../tools/platform_detector.py
```

### Generate Registry for Your Platform

```bash
# Auto-detect and generate
python3 ../tools/build_registry.py --auto-detect

# Or specify platform
python3 ../tools/build_registry.py --platform platforms/linux/ubuntu/desktop
```

### Generate Registry for All Platforms

```bash
python3 ../tools/build_registry.py --all-platforms
```

## Platform Status

### ✅ Fully Implemented
- **Linux → Ubuntu → Desktop**: 308 rules (CIS Ubuntu Linux Benchmark)

### 🚧 In Development
- **Linux → Ubuntu → Server**: Planned
- **Linux → Debian**: Planned
- **Linux → RHEL**: Planned
- **Linux → CentOS**: Planned
- **Windows → Desktop (Win10/Win11)**: Planned
- **Windows → Server (2019/2022)**: Planned
- **Android**: Planned

### 📋 Planned
- **Linux → Common**: Distribution-independent rules
- **macOS**: Desktop (Ventura, Sonoma)
- **iOS**: Mobile devices
- **FreeBSD**: Server

## Adding a New Platform

See the [Adding New Platforms Guide](../docs/development/adding-new-platform.md) for detailed instructions.

Quick steps:
1. Create directory structure: `platforms/<platform>/<variant>/rules/`
2. Add `metadata.json`
3. Create or port rules
4. Generate registry
5. Test thoroughly

## Platform Metadata

Each platform includes a `metadata.json` file with:
- Platform and distribution information
- Supported versions
- Benchmark reference and version
- Automation methods supported
- Inheritance relationships
- Maintenance information

Example:
```json
{
  "platform": "linux",
  "distribution": "ubuntu",
  "variant": "desktop",
  "versions": ["20.04", "22.04", "24.04"],
  "benchmark": "CIS Ubuntu Linux Benchmark",
  "benchmark_version": "v2.0.0",
  "supported_automation": ["bash", "ansible", "python"]
}
```

## Platform-Specific Documentation

- [Linux Platforms](../docs/platforms/linux.md)
- [Windows Platforms](../docs/platforms/windows.md)
- [Android Platform](../docs/platforms/android.md)

## Contributing

We welcome contributions for:
- New platform support
- Additional distribution support
- Rule improvements
- Documentation enhancements

Please see the [Contributing Guide](../docs/development/adding-new-platform.md) for details.
