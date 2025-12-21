# 5.3.3.3.2 Ensure password history is enforced for the root user (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
Ensure password history rules apply to the root user.

## Rationale
The root user's password should follow the same history requirements.

## Audit
```bash
grep -Pi -- '^\h*enforce_for_root\b' /etc/security/pwhistory.conf
```
Verify `enforce_for_root` is set.

## Remediation
```bash
echo "enforce_for_root" >> /etc/security/pwhistory.conf
```

## References
- NIST SP 800-53 Rev. 5: IA-5
