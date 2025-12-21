# 2.2.3 Ensure nis client is not installed (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The NIS client (ypbind) is used to bind to an NIS server and receive NIS data.

## Rationale
NIS is inherently insecure. If NIS is not required, remove the client.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' nis
```

## Remediation
```bash
apt purge nis
```
