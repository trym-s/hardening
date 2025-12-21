# 5.1.1 Ensure permissions on /etc/ssh/sshd_config are configured (Automated)

## Description
The `/etc/ssh/sshd_config` file contains configuration specifications for `sshd`. The file should be protected from unauthorized changes.

## Rationale
The `/etc/ssh/sshd_config` file should be protected from unauthorized changes by non-privileged users.

## Audit
```bash
stat -Lc "%a %u %g" /etc/ssh/sshd_config
```
Should return `600 0 0` or more restrictive permissions with owner and group as root.

## Remediation
```bash
chown root:root /etc/ssh/sshd_config
chmod 600 /etc/ssh/sshd_config
```
