# 5.3.3.2.8 Ensure password quality is enforced for the root user (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
Ensure password quality rules apply to the root user.

## Rationale
The root user's password should meet the same complexity requirements.

## Audit
```bash
grep -Pi -- '^\h*enforce_for_root\b' /etc/security/pwquality.conf
```
Verify `enforce_for_root` is set.

## Remediation
```bash
echo "enforce_for_root" >> /etc/security/pwquality.conf
```

## References
- NIST SP 800-53 Rev. 5: IA-5
