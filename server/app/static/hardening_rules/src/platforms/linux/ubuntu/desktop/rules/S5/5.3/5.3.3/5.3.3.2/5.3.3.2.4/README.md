# 5.3.3.2.4 Ensure password same consecutive characters is configured (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `maxrepeat` option limits consecutive identical characters in a password.

## Rationale
Prevents passwords like "aaaa1234" which are easier to guess.

## Audit
```bash
grep -Pi -- '^\h*maxrepeat\h*=' /etc/security/pwquality.conf
```
Verify `maxrepeat` is set to 3 or less.

## Remediation
```bash
echo "maxrepeat = 3" >> /etc/security/pwquality.conf
```

## References
- NIST SP 800-53 Rev. 5: IA-5
