# 3.3.10 Ensure TCP SYN cookies is enabled (Automated)

## Description
TCP SYN cookies is a mechanism that helps protect against SYN flood attacks.

## Rationale
Attackers can initiate a denial of service (DoS) attack by sending SYN packets but never completing the three-way handshake, consuming resources. SYN cookies help mitigate this attack.

## Audit
```bash
sysctl net.ipv4.tcp_syncookies
```
Should return `1`.

## Remediation
```bash
sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.route.flush=1
```
