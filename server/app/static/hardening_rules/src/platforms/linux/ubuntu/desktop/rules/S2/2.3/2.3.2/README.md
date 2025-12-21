# 2.3.2 Ensure systemd-timesyncd configured with authorized timeserver (Manual)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
systemd-timesyncd is a daemon that has been added for synchronizing the system clock across the network. It implements an SNTP client.

## Rationale
If systemd-timesyncd is in use, it should be configured to synchronize time from an authorized NTP server.

## Audit
If systemd-timesyncd is used, verify the NTP configuration:
```bash
timedatectl status
cat /etc/systemd/timesyncd.conf
```

Verify NTP servers are configured appropriately.

## Remediation
Edit /etc/systemd/timesyncd.conf:
```
[Time]
NTP=time.nist.gov pool.ntp.org
FallbackNTP=time.google.com
```

Then restart the service:
```bash
systemctl restart systemd-timesyncd.service
```

## References
1. NIST SP 800-53 Rev. 5: AU-8

## CIS Controls
| Version | Control | IG 1 | IG 2 | IG 3 |
|---------|---------|------|------|------|
| v8 | 8.4 Standardize Time Synchronization | ● | ● | ● |
