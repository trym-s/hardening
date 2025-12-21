# 2.2.4 Ensure rsh client is not installed (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The rsh package contains the client commands for the rsh services.

## Rationale
rsh transmits data in cleartext. Use SSH instead.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' rsh-client
```

## Remediation
```bash
apt purge rsh-client
```
