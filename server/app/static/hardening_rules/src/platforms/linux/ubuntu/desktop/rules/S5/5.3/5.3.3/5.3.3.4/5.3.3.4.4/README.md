# 5.3.3.4.4 Ensure pam_unix includes use_authtok (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `use_authtok` option forces pam_unix to use the password provided by a previous module.

## Rationale
This ensures proper password handling in the PAM stack.

## Audit
```bash
grep -Pi -- '^\h*password\h+[^#\n\r]+\h+pam_unix\.so\b.*\buse_authtok\b' /etc/pam.d/common-password
```

## Remediation
```bash
# Add use_authtok to pam_unix if not present
sed -i '/pam_unix.so/s/$/ use_authtok/' /etc/pam.d/common-password
```

## References
- NIST SP 800-53 Rev. 5: IA-5
