# 5.3.1.3 Ensure libpam-pwquality is installed (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `libpam-pwquality` package provides common functions for password quality checking.

## Rationale
This package is crucial for enforcing password quality and complexity rules.

## Audit
```bash
dpkg-query -W libpam-pwquality
```

## Remediation
```bash
apt install libpam-pwquality -y
```

## References
- NIST SP 800-53 Rev. 5: IA-5
