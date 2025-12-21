# 5.3.3.3.3 Ensure pam_pwhistory includes use_authtok (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `use_authtok` option forces pam_pwhistory to use the password provided by a previous module.

## Rationale
This ensures proper password handling in the PAM stack.

## Audit
```bash
grep -Pi -- '^\h*password\h+[^#\n\r]+\h+pam_pwhistory\.so\h+[^#\n\r]*\buse_authtok\b' /etc/pam.d/common-password
```

## Remediation
Configure `use_authtok` in /etc/security/pwhistory.conf or in pam configuration.

## References
- NIST SP 800-53 Rev. 5: IA-5
