# 4.2.7 Ensure ufw default deny firewall policy (Automated)

## Description
A default deny policy blocks all traffic that is not explicitly permitted.

## Rationale
Default deny provides a more secure baseline and requires explicit rules for allowed traffic.

## Audit
```bash
ufw status verbose
```
Should show "Default: deny (incoming)" as the default policy.

## Remediation
```bash
ufw default deny incoming
ufw default allow outgoing
ufw default deny routed
```
