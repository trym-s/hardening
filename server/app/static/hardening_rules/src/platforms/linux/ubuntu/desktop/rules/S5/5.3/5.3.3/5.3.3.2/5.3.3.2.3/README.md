# 5.3.3.2.3 Ensure password complexity is configured (Manual)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
Configure password complexity by requiring different character classes.

## Rationale
Complex passwords are harder to guess or crack.

## Audit
```bash
grep -Pi -- '^\h*(minclass|[dulo]credit)\h*=' /etc/security/pwquality.conf
```
Verify appropriate complexity settings.

## Remediation
```bash
# Option 1: Use minclass (minimum character classes)
echo "minclass = 4" >> /etc/security/pwquality.conf

# Option 2: Use individual credits (negative values = required)
echo "dcredit = -1" >> /etc/security/pwquality.conf  # digit
echo "ucredit = -1" >> /etc/security/pwquality.conf  # uppercase
echo "lcredit = -1" >> /etc/security/pwquality.conf  # lowercase
echo "ocredit = -1" >> /etc/security/pwquality.conf  # special
```

## References
- NIST SP 800-53 Rev. 5: IA-5
