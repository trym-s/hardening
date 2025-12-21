# 5.3.3.1.2 Ensure password unlock time is configured (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
Configure how long an account remains locked after exceeding failed login attempts.

## Rationale
Setting an appropriate unlock time prevents permanent lockouts while deterring brute-force attacks.

## Audit
```bash
grep -Pi -- '^\h*unlock_time\h*=' /etc/security/faillock.conf
```
Verify `unlock_time` is set to 0 (never unlock, requires admin) or 900 seconds or more.

## Remediation
```bash
echo "unlock_time = 900" >> /etc/security/faillock.conf
```

## References
- NIST SP 800-53 Rev. 5: AC-7
