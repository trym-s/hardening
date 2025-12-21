# 3.3.4 Ensure broadcast ICMP requests are ignored (Automated)

## Description
Setting icmp_echo_ignore_broadcasts to 1 will cause the system to ignore all ICMP echo and timestamp requests to broadcast and multicast addresses.

## Rationale
This protects against Smurf attacks and other broadcast-based denial of service attacks.

## Audit
```bash
sysctl net.ipv4.icmp_echo_ignore_broadcasts
```
Should return `1`.

## Remediation
```bash
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.route.flush=1
```
