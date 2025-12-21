# 2.1.10 Ensure nis server services are not in use (Automated)

## Description
NIS (Network Information Service) is a client-server directory service.

## Rationale
NIS is inherently insecure and should not be used.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' nis
systemctl is-enabled ypserv.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop ypserv.service
systemctl mask ypserv.service
apt purge nis
```
