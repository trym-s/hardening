# 3.3.3 Ensure bogus ICMP responses are ignored (Automated)

## Description
Setting icmp_ignore_bogus_error_responses to 1 prevents the kernel from logging bogus responses.

## Rationale
Some routers violate RFC1122 by sending bogus responses to broadcast frames. Such violations are normally logged, but this logging could fill up a disk and allow a denial of service attack.

## Audit
```bash
sysctl net.ipv4.icmp_ignore_bogus_error_responses
```
Should return `1`.

## Remediation
```bash
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.route.flush=1
```
