# 2.1.14 Ensure samba file server services are not in use (Automated)

## Description
Samba allows for network file and print sharing between Unix and Windows systems.

## Rationale
Unless specifically required, disable samba to reduce attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' samba
systemctl is-enabled smbd.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop smbd.service
systemctl mask smbd.service
apt purge samba
```
