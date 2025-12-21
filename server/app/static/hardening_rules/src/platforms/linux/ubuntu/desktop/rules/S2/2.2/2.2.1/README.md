# 2.2.1 Ensure ftp client is not installed (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
FTP (File Transfer Protocol) is a traditional and widely used standard tool for transferring files between a server and clients over a network.

## Rationale
FTP transmits data in cleartext without encryption. Use more secure alternatives like SFTP.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' ftp
```
Nothing should be returned or status should show not-installed.

## Remediation
```bash
apt purge ftp
```

## References
1. NIST SP 800-53 Rev. 5: CM-7

## CIS Controls
| Version | Control | IG 1 | IG 2 | IG 3 |
|---------|---------|------|------|------|
| v8 | 4.8 Uninstall or Disable Unnecessary Services | | ● | ● |
