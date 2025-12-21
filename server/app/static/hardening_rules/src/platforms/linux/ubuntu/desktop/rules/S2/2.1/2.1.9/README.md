# 2.1.9 Ensure network file system services are not in use (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
NFS is a distributed file system protocol which allows a user to access files over a network.

## Rationale
If the system is not configured as an NFS server, disable the service to reduce attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' nfs-kernel-server
systemctl is-enabled nfs-server.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop nfs-server.service
systemctl mask nfs-server.service
apt purge nfs-kernel-server
```
