# 5.3.3.3.1 Ensure password history remember is configured (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `remember` option sets the number of old passwords to remember.

## Rationale
Password history prevents users from re-using recent passwords.

## Audit
```bash
grep -Pi -- '^\h*remember\h*=' /etc/security/pwhistory.conf
```
Verify `remember` is set to 24 or more.

## Remediation
```bash
echo "remember = 24" >> /etc/security/pwhistory.conf
```

## References
- NIST SP 800-53 Rev. 5: IA-5
