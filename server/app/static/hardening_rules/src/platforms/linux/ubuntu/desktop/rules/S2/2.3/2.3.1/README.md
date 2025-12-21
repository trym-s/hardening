# 2.3.1 Ensure time synchronization is in use (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
System time should be synchronized between all systems in an environment. This is typically done by establishing an authoritative time server or set of servers and having all systems synchronize their clocks to them.

## Rationale
Time synchronization is important to support time sensitive security mechanisms like Kerberos and also ensures log files have consistent time records for forensic analysis.

## Audit
Verify that a time synchronization service is installed and enabled:
```bash
systemctl is-enabled systemd-timesyncd.service 2>/dev/null
# OR
systemctl is-enabled chrony.service 2>/dev/null
```
One of them should return "enabled".

## Remediation
Install and enable a time synchronization service:
```bash
# Option 1: systemd-timesyncd (default)
systemctl unmask systemd-timesyncd.service
systemctl enable --now systemd-timesyncd.service

# Option 2: chrony
apt install chrony
systemctl enable --now chrony.service
```

## References
1. NIST SP 800-53 Rev. 5: AU-8

## CIS Controls
| Version | Control | IG 1 | IG 2 | IG 3 |
|---------|---------|------|------|------|
| v8 | 8.4 Standardize Time Synchronization | ● | ● | ● |
