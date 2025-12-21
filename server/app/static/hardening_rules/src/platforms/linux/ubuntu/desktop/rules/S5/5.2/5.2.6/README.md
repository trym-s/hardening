# 5.2.6 Ensure sudo authentication timeout is configured correctly (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
sudo caches credentials for a period of time. The default timeout is 15 minutes.

## Rationale
A shorter timeout period reduces the window of opportunity for unauthorized privilege escalation.

## Audit
```bash
grep -rPi -- '^\h*Defaults\h+([^#]+,\h*)?timestamp_timeout\h*=' /etc/sudoers*
```
Verify `timestamp_timeout` is set to 15 minutes or less (e.g., `timestamp_timeout=15`).

## Remediation
```bash
echo 'Defaults timestamp_timeout=15' >> /etc/sudoers.d/timeout
```

## References
- NIST SP 800-53 Rev. 5: IA-11
