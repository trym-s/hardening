# 5.3.2.1 Ensure pam_unix module is enabled (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `pam_unix` module handles traditional Unix password-based authentication.

## Rationale
This module is essential for standard password authentication on Unix systems.

## Audit
```bash
grep -P -- '\bpam_unix\.so\b' /etc/pam.d/common-{password,auth}
```

## Remediation
```bash
pam-auth-update --enable unix
```

## References
- NIST SP 800-53 Rev. 5: IA-5
