# 5.3.2.3 Ensure pam_pwquality module is enabled (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `pam_pwquality` module enforces password complexity policies.

## Rationale
Strong password complexity requirements help prevent weak passwords.

## Audit
```bash
grep -P -- '\bpam_pwquality\.so\b' /etc/pam.d/common-password
```

## Remediation
```bash
pam-auth-update --enable pwquality
```

## References
- NIST SP 800-53 Rev. 5: IA-5
