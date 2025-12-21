# 5.3.3.4.2 Ensure pam_unix does not include remember (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `remember` option in pam_unix should not be used; use pam_pwhistory instead.

## Rationale
Password history should be managed by pam_pwhistory, not pam_unix.

## Audit
```bash
grep -Pi -- '^\h*password\h+[^#\n\r]+\h+pam_unix\.so\b.*\bremember=' /etc/pam.d/common-password
```
Verify `remember` is not present in pam_unix.

## Remediation
```bash
sed -i 's/\s*remember=[0-9]*//g' /etc/pam.d/common-password
```

## References
- NIST SP 800-53 Rev. 5: IA-5
