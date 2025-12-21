# 5.1.20 Ensure sshd PermitRootLogin is disabled (Automated)

## Description
The `PermitRootLogin` parameter specifies if the root user can log in using SSH.

## Rationale
Disallowing root logins over SSH requires system administrators to authenticate using their own individual account before elevating to root.

## Audit
```bash
sshd -T | grep permitrootlogin
```
Should return `permitrootlogin no`.

## Remediation
```bash
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
systemctl reload sshd
```
