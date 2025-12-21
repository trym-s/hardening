# 2.2.7 Ensure tftp client is not installed (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
Trivial File Transfer Protocol (TFTP) is a simple, lockstep file transfer protocol for transferring files.

## Rationale
TFTP does not support authentication or encryption. If not required, remove it.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' tftp
```

## Remediation
```bash
apt purge tftp
```
