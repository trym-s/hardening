# 2.3.3 Ensure chrony is configured with authorized timeserver (Manual)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
chrony is a versatile implementation of the Network Time Protocol (NTP). It can synchronize the system clock with NTP servers, reference clocks, and manual input.

## Rationale
If chrony is in use on the system, ensure that it is configured to synchronize time from an authorized time server.

## Audit
If chrony is used, verify the NTP configuration:
```bash
grep -E "^(server|pool)" /etc/chrony/chrony.conf /etc/chrony/conf.d/*.conf 2>/dev/null
```

Verify NTP servers are configured appropriately.

## Remediation
Edit /etc/chrony/chrony.conf and configure authorized NTP servers:
```
pool time.nist.gov iburst
pool pool.ntp.org iburst
```

Then restart chrony:
```bash
systemctl restart chrony.service
```

## References
1. NIST SP 800-53 Rev. 5: AU-8

## CIS Controls
| Version | Control | IG 1 | IG 2 | IG 3 |
|---------|---------|------|------|------|
| v8 | 8.4 Standardize Time Synchronization | ● | ● | ● |
