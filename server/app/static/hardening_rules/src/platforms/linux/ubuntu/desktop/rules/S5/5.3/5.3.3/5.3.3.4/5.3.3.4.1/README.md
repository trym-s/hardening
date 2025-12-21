# 5.3.3.4.1 Ensure pam_unix does not include nullok (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `nullok` option allows users to change their password from a blank password.

## Rationale
Blank passwords should not be allowed.

## Audit
```bash
grep -Pi -- '^\h*[^#\n\r]+\h+pam_unix\.so\b' /etc/pam.d/common-{password,auth} | grep nullok
```
Verify `nullok` is not present.

## Remediation
```bash
sed -i 's/\s*nullok//g' /etc/pam.d/common-password
sed -i 's/\s*nullok//g' /etc/pam.d/common-auth
```

## References
- NIST SP 800-53 Rev. 5: IA-5
