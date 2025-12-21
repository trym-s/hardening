# 5.3.3.1.1 Ensure password failed attempts lockout is configured (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
Lock out users after a specified number of failed login attempts.

## Rationale
Account lockout prevents brute-force password attacks.

## Audit
```bash
grep -Pi -- '^\h*deny\h*=' /etc/security/faillock.conf
```
Verify `deny` is set to 5 or less.

## Remediation
```bash
sed -i 's/^#\s*deny\s*=.*/deny = 5/' /etc/security/faillock.conf
# Or add if not present
echo "deny = 5" >> /etc/security/faillock.conf
```

## References
- NIST SP 800-53 Rev. 5: AC-7
