# 5.3.1.1 Ensure latest version of pam is installed (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `libpam-runtime` package contains the necessary files for PAM to function properly.

## Rationale
PAM version 1.5.3-5 or later is required for full functionality and access to all benchmark options.

## Audit
```bash
dpkg-query -W libpam-runtime
```
Verify the version is 1.5.3-5 or later.

## Remediation
```bash
apt update && apt upgrade libpam-runtime -y
```

## References
- NIST SP 800-53 Rev. 5: CM-6
