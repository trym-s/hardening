# 3.3.9 Ensure suspicious packets are logged (Automated)

## Description
When enabled, this setting logs martian packets (impossible addresses) and other suspicious packets.

## Rationale
Logging suspicious packets enables forensic analysis and attack detection.

## Audit
```bash
sysctl net.ipv4.conf.all.log_martians
sysctl net.ipv4.conf.default.log_martians
```
All should return `1`.

## Remediation
```bash
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1
```
