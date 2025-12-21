# 5.3.3.4.3 Ensure pam_unix includes a strong password hashing algorithm (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
Configure pam_unix to use strong hashing algorithms (sha512 or yescrypt).

## Rationale
Weak hashing algorithms can be cracked more easily.

## Audit
```bash
grep -Pi -- '^\h*password\h+[^#\n\r]+\h+pam_unix\.so\b' /etc/pam.d/common-password | grep -E '(sha512|yescrypt)'
```

## Remediation
```bash
# Add yescrypt or sha512 to pam_unix configuration
sed -i 's/pam_unix.so.*/& yescrypt/' /etc/pam.d/common-password
```

## References
- NIST SP 800-53 Rev. 5: IA-5
