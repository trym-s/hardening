# 5.3.3.2.7 Ensure password quality checking is enforced (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
Ensure password quality is enforced for all users.

## Rationale
Password quality rules should be applied consistently.

## Audit
```bash
grep -Pi -- '^\h*enforcing\h*=' /etc/security/pwquality.conf
```
Verify `enforcing` is not set to 0.

## Remediation
```bash
sed -i '/^enforcing\s*=\s*0/d' /etc/security/pwquality.conf
echo "enforcing = 1" >> /etc/security/pwquality.conf
```

## References
- NIST SP 800-53 Rev. 5: IA-5
