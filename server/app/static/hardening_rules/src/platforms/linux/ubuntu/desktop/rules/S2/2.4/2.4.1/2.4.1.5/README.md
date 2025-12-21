# 2.4.1.5 Ensure permissions on /etc/cron.weekly are configured (Automated)

## Description
The /etc/cron.weekly directory contains system cron jobs that need to run on a weekly basis.

## Rationale
Granting write access to this directory could provide unprivileged users with the ability to gain elevated privileges, and granting read access would allow users to view scripts that may contain sensitive information.

## Audit
Run the following command to verify permissions on /etc/cron.weekly:
```bash
stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/cron.weekly
```
Expected output should show ownership as root:root and permissions as 700 or more restrictive.

## Remediation
Run the following commands to set permissions on /etc/cron.weekly:
```bash
chown root:root /etc/cron.weekly
chmod 700 /etc/cron.weekly
```
