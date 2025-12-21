# 5.1.22 Ensure sshd UsePAM is enabled (Automated)

## Description
`UsePAM` enables the Pluggable Authentication Module interface.

## Rationale
When `UsePAM` is enabled, PAM modules can be used for authentication, account management, session management, and password management.

## Audit
```bash
sshd -T | grep -i usepam
```
Should return `usepam yes`.

## Remediation
```bash
echo "UsePAM yes" >> /etc/ssh/sshd_config
systemctl reload sshd
```
