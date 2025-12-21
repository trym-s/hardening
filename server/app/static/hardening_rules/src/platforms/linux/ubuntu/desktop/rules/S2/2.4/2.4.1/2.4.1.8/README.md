# 2.4.1.8 Ensure crontab is restricted to authorized users (Automated)

## Description
If cron is installed, the crontab command can be used to submit, edit, list, or remove cron jobs. Access to crontab should be restricted to authorized users.

## Rationale
Configure cron to allow only authorized users to schedule cron jobs. This helps prevent unauthorized users from gaining access to system resources or escalating privileges.

If `/etc/cron.allow` exists, only users listed in this file can use crontab. If `/etc/cron.allow` does not exist, `/etc/cron.deny` is checked and users NOT listed in cron.deny can use crontab. Using cron.allow (whitelist) is preferred over cron.deny (blacklist).

## Audit
Run the following commands to verify crontab is restricted to authorized users:

1. Verify /etc/cron.deny does not exist:
```bash
stat /etc/cron.deny
```
This should return "No such file or directory"

2. Verify /etc/cron.allow exists with correct permissions:
```bash
stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/cron.allow
```
Expected: owned by root:root with permissions 640 or more restrictive.

## Remediation
Run the following commands to remove cron.deny, create cron.allow, and set permissions:
```bash
rm -f /etc/cron.deny
touch /etc/cron.allow
chown root:root /etc/cron.allow
chmod 640 /etc/cron.allow
```
