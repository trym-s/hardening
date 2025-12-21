# 5.1.19 Ensure sshd PermitEmptyPasswords is disabled (Automated)

## Description
The `PermitEmptyPasswords` parameter specifies if the SSH server allows login to accounts with empty password strings.

## Rationale
Disallowing remote shell access to accounts that have an empty password reduces the probability of unauthorized access.

## Audit
```bash
sshd -T | grep permitemptypasswords
```
Should return `permitemptypasswords no`.

## Remediation
```bash
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
systemctl reload sshd
```
