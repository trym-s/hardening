# 2.2.2 Ensure ldap client is not installed (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The Lightweight Directory Access Protocol (LDAP) client package provides commands and an interface for accessing directory services.

## Rationale
If LDAP is not required, remove the client to reduce the potential attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' ldap-utils
```

## Remediation
```bash
apt purge ldap-utils
```
