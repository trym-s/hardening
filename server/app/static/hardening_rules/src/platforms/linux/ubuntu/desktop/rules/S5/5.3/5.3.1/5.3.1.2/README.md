# 5.3.1.2 Ensure libpam-modules is installed (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `libpam-modules` package provides the core PAM modules.

## Rationale
This package is essential for various PAM modules to function properly.

## Audit
```bash
dpkg-query -W libpam-modules
```

## Remediation
```bash
apt install libpam-modules -y
```

## References
- NIST SP 800-53 Rev. 5: CM-6
