# 5.1.16 Ensure sshd MaxAuthTries is configured (Automated)

## Description
The `MaxAuthTries` parameter specifies the maximum number of authentication attempts permitted per connection.

## Rationale
Setting the `MaxAuthTries` parameter to a low number will minimize the risk of successful brute force attacks.

## Audit
```bash
sshd -T | grep maxauthtries
```
Should return `maxauthtries 4` or less.

## Remediation
```bash
echo "MaxAuthTries 4" >> /etc/ssh/sshd_config
systemctl reload sshd
```
