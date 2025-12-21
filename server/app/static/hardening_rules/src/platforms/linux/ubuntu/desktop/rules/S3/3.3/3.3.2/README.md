# 3.3.2 Ensure packet redirect sending is disabled (Automated)

## Description
ICMP Redirects are used to send routing information to other hosts.

## Rationale
An attacker could use a compromised host to send invalid ICMP redirects to other router devices in an attempt to corrupt routing.

## Audit
Run the following commands:
```bash
sysctl net.ipv4.conf.all.send_redirects
sysctl net.ipv4.conf.default.send_redirects
```
Both should return `0`.

## Remediation
```bash
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.route.flush=1
```
