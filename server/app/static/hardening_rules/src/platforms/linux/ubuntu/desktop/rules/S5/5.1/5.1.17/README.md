# 5.1.17 Ensure sshd MaxSessions is configured (Automated)

## Description
The `MaxSessions` parameter specifies the maximum number of open sessions permitted per network connection.

## Rationale
To protect a system from denial of service due to a large number of concurrent sessions, set the `MaxSessions` parameter to 10 or less.

## Audit
```bash
sshd -T | grep maxsessions
```
Should return `maxsessions 10` or less.

## Remediation
```bash
echo "MaxSessions 10" >> /etc/ssh/sshd_config
systemctl reload sshd
```
