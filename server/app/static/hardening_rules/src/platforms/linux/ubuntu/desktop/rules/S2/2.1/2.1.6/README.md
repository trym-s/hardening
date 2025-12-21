# 2.1.6 Ensure ftp server services are not in use (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
FTP (File Transfer Protocol) is a traditional and widely used standard tool for transferring files between a server and clients over a network.

## Rationale
FTP does not protect the confidentiality of data or authentication credentials. It is recommended to use more secure SFTP or FTPS instead.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' vsftpd
systemctl is-enabled vsftpd.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop vsftpd.service
systemctl mask vsftpd.service
apt purge vsftpd
```
