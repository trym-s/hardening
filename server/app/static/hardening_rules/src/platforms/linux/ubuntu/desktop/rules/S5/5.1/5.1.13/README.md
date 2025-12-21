# 5.1.13 Ensure sshd LoginGraceTime is configured (Automated)

## Description
The `LoginGraceTime` parameter specifies the time allowed for successful authentication to the SSH server.

## Rationale
Setting the `LoginGraceTime` parameter to a low number will minimize the risk of successful brute force attacks.

## Audit
```bash
sshd -T | grep logingracetime
```
Should return `logingracetime 60` or less.

## Remediation
```bash
echo "LoginGraceTime 60" >> /etc/ssh/sshd_config
systemctl reload sshd
```
