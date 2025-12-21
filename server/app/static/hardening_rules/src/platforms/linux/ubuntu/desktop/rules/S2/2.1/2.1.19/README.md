# 2.1.19 Ensure web server services are not in use (Automated)

## Description
Web servers can be attacked in multiple ways including DDoS, injection attacks, and more.

## Rationale
Unless specifically required, disable web server services to reduce attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' apache2 nginx
systemctl is-enabled apache2.service nginx.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop apache2.service nginx.service
systemctl mask apache2.service nginx.service
apt purge apache2 nginx
```
