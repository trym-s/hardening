# 2.4.1.2 Ensure permissions on /etc/crontab are configured (Automated)

## Description
The /etc/crontab file is used by cron to control its own jobs.

## Rationale
The /etc/crontab file contains system-level cron jobs that only the root user should have access to read, modify, or execute. Restricting access to this file prevents unprivileged users from viewing, modifying, or leveraging system jobs for privilege escalation.

## Audit
Run the following command to verify permissions on /etc/crontab:
```bash
stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/crontab
```
Expected output should show ownership as root:root and permissions as 600 or more restrictive.

## Remediation
Run the following commands to set permissions on /etc/crontab:
```bash
chown root:root /etc/crontab
chmod 600 /etc/crontab
```
