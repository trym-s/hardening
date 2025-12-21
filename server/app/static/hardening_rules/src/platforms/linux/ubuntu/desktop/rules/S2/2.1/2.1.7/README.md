# 2.1.7 Ensure ldap server services are not in use (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The Lightweight Directory Access Protocol (LDAP) is used to provide directory services (user names, groups) to systems.

## Rationale
If the system is not configured to be an LDAP server, it is recommended to disable this service.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' slapd
systemctl is-enabled slapd.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop slapd.service
systemctl mask slapd.service
apt purge slapd
```
