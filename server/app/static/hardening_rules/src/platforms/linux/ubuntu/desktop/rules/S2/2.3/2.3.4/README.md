# 2.3.4 Ensure ntp is configured with authorized timeserver (Manual)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
ntp is a daemon which implements the Network Time Protocol (NTP). It maintains the system time in synchronization with time-servers.

## Rationale
If ntp is in use, it should be configured to synchronize time from authorized NTP servers. Note: ntp is deprecated in favor of chrony or systemd-timesyncd.

## Audit
If ntp is used, verify the NTP configuration:
```bash
grep -E "^(server|pool)" /etc/ntp.conf
```

## Remediation
Edit /etc/ntp.conf and configure authorized NTP servers:
```
server time.nist.gov iburst
pool pool.ntp.org iburst
```

Restart ntp:
```bash
systemctl restart ntp.service
```

## References
1. NIST SP 800-53 Rev. 5: AU-8

## CIS Controls
| Version | Control | IG 1 | IG 2 | IG 3 |
|---------|---------|------|------|------|
| v8 | 8.4 Standardize Time Synchronization | ● | ● | ● |
