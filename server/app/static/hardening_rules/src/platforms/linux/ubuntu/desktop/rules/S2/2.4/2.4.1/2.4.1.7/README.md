# 2.4.1.7 Ensure permissions on /etc/cron.d are configured (Automated)

## Description
The /etc/cron.d directory contains system cron jobs that need to run in a similar manner to /etc/crontab and is used for more granular scheduling.

## Rationale
Granting write access to this directory could provide unprivileged users with the ability to gain elevated privileges, and granting read access would allow users to view scripts that may contain sensitive information.

## Audit
Run the following command to verify permissions on /etc/cron.d:
```bash
stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/cron.d
```
Expected output should show ownership as root:root and permissions as 700 or more restrictive.

## Remediation
Run the following commands to set permissions on /etc/cron.d:
```bash
chown root:root /etc/cron.d
chmod 700 /etc/cron.d
```
