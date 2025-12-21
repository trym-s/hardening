# 2.1.18 Ensure web proxy server services are not in use (Automated)

## Description
Squid is a caching proxy for the Web supporting HTTP, HTTPS, FTP, and more.

## Rationale
Unless specifically required, disable the web proxy server to reduce attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' squid
systemctl is-enabled squid.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop squid.service
systemctl mask squid.service
apt purge squid
```
