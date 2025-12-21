# 5.3.2.4 Ensure pam_pwhistory module is enabled (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `pam_pwhistory` module helps prevent users from reusing old passwords.

## Rationale
Password reuse restrictions force users to choose new passwords.

## Audit
```bash
grep -P -- '\bpam_pwhistory\.so\b' /etc/pam.d/common-password
```

## Remediation
```bash
pam-auth-update --enable pwhistory
```

## References
- NIST SP 800-53 Rev. 5: IA-5
