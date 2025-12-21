# 2.1.4 Ensure dns server services are not in use (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The Domain Name System (DNS) is a hierarchical naming system that maps names to IP addresses for computers, services and other resources connected to a network.

## Rationale
Unless a system is specifically designated to act as a DNS server, it is recommended to disable the service to reduce the potential attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' bind9
systemctl is-enabled named.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop named.service
systemctl mask named.service
apt purge bind9
```
