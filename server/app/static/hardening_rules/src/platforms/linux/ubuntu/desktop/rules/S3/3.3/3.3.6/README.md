# 3.3.6 Ensure secure ICMP redirects are not accepted (Automated)

## Description
Secure ICMP redirects are the same as ICMP redirects, except they come from gateways listed in the default gateway list.

## Rationale
It is recommended that systems do not accept secure ICMP redirects as they could still be used for malicious purposes.

## Audit
```bash
sysctl net.ipv4.conf.all.secure_redirects
sysctl net.ipv4.conf.default.secure_redirects
```
All should return `0`.

## Remediation
```bash
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
```
