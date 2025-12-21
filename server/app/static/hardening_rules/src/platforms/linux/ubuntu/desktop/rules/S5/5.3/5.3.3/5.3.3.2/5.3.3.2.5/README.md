# 5.3.3.2.5 Ensure password maximum sequential characters is configured (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `maxsequence` option limits sequential characters (e.g., "abc", "123") in a password.

## Rationale
Prevents easily guessable sequential patterns.

## Audit
```bash
grep -Pi -- '^\h*maxsequence\h*=' /etc/security/pwquality.conf
```
Verify `maxsequence` is set to 3 or less.

## Remediation
```bash
echo "maxsequence = 3" >> /etc/security/pwquality.conf
```

## References
- NIST SP 800-53 Rev. 5: IA-5
