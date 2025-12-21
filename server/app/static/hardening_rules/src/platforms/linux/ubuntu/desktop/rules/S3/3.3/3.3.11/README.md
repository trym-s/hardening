# 3.3.11 Ensure IPv6 router advertisements are not accepted (Automated)

## Description
This setting disables the system's ability to accept IPv6 router advertisements.

## Rationale
It is recommended that systems do not accept router advertisements as they could be tricked into routing traffic to compromised machines. Setting hard routes within the system reduces the possible sources of rogue routing information.

## Audit
```bash
sysctl net.ipv6.conf.all.accept_ra
sysctl net.ipv6.conf.default.accept_ra
```
Both should return `0`.

## Remediation
```bash
sysctl -w net.ipv6.conf.all.accept_ra=0
sysctl -w net.ipv6.conf.default.accept_ra=0
sysctl -w net.ipv6.route.flush=1
```
