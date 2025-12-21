# 2.1.17 Ensure tftp server services are not in use (Automated)

## Description
TFTP (Trivial File Transfer Protocol) is a simple, lockstep, file transfer protocol.

## Rationale
TFTP is insecure as it does not provide authentication. Disable unless specifically required.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' tftpd-hpa
systemctl is-enabled tftpd-hpa.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop tftpd-hpa.service
systemctl mask tftpd-hpa.service
apt purge tftpd-hpa
```
