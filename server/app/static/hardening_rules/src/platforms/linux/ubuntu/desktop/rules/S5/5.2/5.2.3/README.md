# 5.2.3 Ensure sudo log file exists (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
sudo can use a custom log file.

## Rationale
A sudo log file simplifies auditing of sudo commands.

## Audit
```bash
grep -rPsi -- '^\h*Defaults\h+([^#]+,\h*)?logfile\h*=\h*(")?[^#"]+(")?' /etc/sudoers*
```
Verify output includes a logfile setting like `Defaults logfile="/var/log/sudo.log"`.

## Remediation
```bash
echo 'Defaults logfile="/var/log/sudo.log"' >> /etc/sudoers.d/logfile
```

## References
- NIST SP 800-53 Rev. 5: AU-3, AU-12
