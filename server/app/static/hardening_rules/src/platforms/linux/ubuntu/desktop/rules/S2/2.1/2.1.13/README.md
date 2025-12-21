# 2.1.13 Ensure rsync services are not in use (Automated)

## Description
rsync is a utility that provides fast incremental file transfer.

## Rationale
Unless specifically required, disable rsync service to reduce attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' rsync
systemctl is-enabled rsync.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop rsync.service
systemctl mask rsync.service
apt purge rsync
```
