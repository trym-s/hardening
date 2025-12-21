# 2.2.6 Ensure telnet client is not installed (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The telnet package contains the telnet client, which allows users to connect to remote systems over the telnet protocol.

## Rationale
Telnet transmits data in cleartext without encryption. Use SSH instead.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' telnet
```

## Remediation
```bash
apt purge telnet
```
