# 5.1.18 Ensure sshd MaxStartups is configured (Automated)

## Description
The `MaxStartups` parameter specifies the maximum number of concurrent unauthenticated connections to the SSH daemon.

## Rationale
To protect a system from denial of service due to a large number of pending authentication connection attempts, use the `MaxStartups` parameter.

## Audit
```bash
sshd -T | grep maxstartups
```
Should return `maxstartups 10:30:60` or similar appropriate values.

## Remediation
```bash
echo "MaxStartups 10:30:60" >> /etc/ssh/sshd_config
systemctl reload sshd
```
