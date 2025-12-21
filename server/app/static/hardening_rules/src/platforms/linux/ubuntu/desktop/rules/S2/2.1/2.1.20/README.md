# 2.1.20 Ensure xinetd services are not in use (Automated)

## Description
xinetd is a super-server daemon that listens for incoming requests for services.

## Rationale
xinetd is an older service that has security vulnerabilities. Disable unless specifically required.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' xinetd
systemctl is-enabled xinetd.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop xinetd.service
systemctl mask xinetd.service
apt purge xinetd
```
