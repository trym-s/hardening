# 2.2.5 Ensure talk client is not installed (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The talk package allows users to send and receive messages across systems through a terminal session.

## Rationale
The talk protocol does not support encryption. If not required, remove it.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' talk
```

## Remediation
```bash
apt purge talk
```
