# 3.3.5 Ensure ICMP redirects are not accepted (Automated)

## Description
ICMP redirect messages are packets that convey routing information and tell your host to send packets via an alternate path.

## Rationale
Attackers could use bogus ICMP redirect messages to maliciously alter the system routing tables.

## Audit
```bash
sysctl net.ipv4.conf.all.accept_redirects
sysctl net.ipv4.conf.default.accept_redirects
sysctl net.ipv6.conf.all.accept_redirects
sysctl net.ipv6.conf.default.accept_redirects
```
All should return `0`.

## Remediation
```bash
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.default.accept_redirects=0
```
