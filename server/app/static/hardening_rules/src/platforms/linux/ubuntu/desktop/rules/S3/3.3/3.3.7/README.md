# 3.3.7 Ensure reverse path filtering is enabled (Automated)

## Description
Setting net.ipv4.conf.all.rp_filter and net.ipv4.conf.default.rp_filter to 1 forces the Linux kernel to use strict reverse path verification.

## Rationale
Enables reverse path filtering to prevent IP spoofing attacks. Packets are dropped if the source address is not reachable through the interface they arrived on.

## Audit
```bash
sysctl net.ipv4.conf.all.rp_filter
sysctl net.ipv4.conf.default.rp_filter
```
All should return `1`.

## Remediation
```bash
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1
```
