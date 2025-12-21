# 5.3.3.2.6 Ensure password dictionary check is enabled (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `dictcheck` option enables checking passwords against a dictionary.

## Rationale
Prevents the use of common words found in dictionaries.

## Audit
```bash
grep -Pi -- '^\h*dictcheck\h*=' /etc/security/pwquality.conf
```
Verify `dictcheck` is not set to 0 (enabled by default when not set).

## Remediation
```bash
# Remove any dictcheck = 0
sed -i '/^dictcheck\s*=\s*0/d' /etc/security/pwquality.conf
echo "dictcheck = 1" >> /etc/security/pwquality.conf
```

## References
- NIST SP 800-53 Rev. 5: IA-5
