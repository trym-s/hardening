# 4.2.4 Ensure ufw loopback traffic is configured (Automated)

## Description
Configure the loopback interface to accept traffic and deny all non-loopback traffic from the 127.0.0.0/8 address range.

## Rationale
Loopback traffic is required for many services to function properly.

## Audit
```bash
ufw status verbose
```
Should show rules allowing traffic on lo interface and denying 127.0.0.0/8 from non-lo interfaces.

## Remediation
```bash
ufw allow in on lo
ufw allow out on lo
ufw deny in from 127.0.0.0/8
ufw deny in from ::1
```
