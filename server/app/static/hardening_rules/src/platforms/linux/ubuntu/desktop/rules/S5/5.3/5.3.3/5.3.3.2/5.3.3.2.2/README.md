# 5.3.3.2.2 Ensure minimum password length is configured (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `minlen` option sets the minimum number of characters in a new password.

## Rationale
Longer passwords are more secure and harder to crack.

## Audit
```bash
grep -Pi -- '^\h*minlen\h*=' /etc/security/pwquality.conf
```
Verify `minlen` is set to 14 or more.

## Remediation
```bash
sed -i 's/^#\?\s*minlen\s*=.*/minlen = 14/' /etc/security/pwquality.conf
```

## References
- NIST SP 800-53 Rev. 5: IA-5
