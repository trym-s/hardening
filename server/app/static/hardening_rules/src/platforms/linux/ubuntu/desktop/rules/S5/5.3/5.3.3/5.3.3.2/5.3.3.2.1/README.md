# 5.3.3.2.1 Ensure password number of changed characters is configured (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `difok` option sets the number of characters in a new password that must not be present in the old password.

## Rationale
Requiring changed characters prevents minor password modifications.

## Audit
```bash
grep -Pi -- '^\h*difok\h*=' /etc/security/pwquality.conf
```
Verify `difok` is set to 2 or more.

## Remediation
```bash
sed -i 's/^#\?\s*difok\s*=.*/difok = 2/' /etc/security/pwquality.conf
```

## References
- NIST SP 800-53 Rev. 5: IA-5
