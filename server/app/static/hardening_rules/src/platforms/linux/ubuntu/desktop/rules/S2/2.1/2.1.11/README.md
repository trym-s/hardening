# 2.1.11 Ensure print server services are not in use (Automated)

## Description
CUPS (Common UNIX Printing System) provides the ability to print to both local and network printers.

## Rationale
If the system does not need to print directly, disable CUPS to reduce attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' cups
systemctl is-enabled cups.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop cups.service
systemctl mask cups.service
apt purge cups
```
