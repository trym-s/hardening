# 2.4.1.4 Ensure permissions on /etc/cron.daily are configured (Automated)

## Description
The /etc/cron.daily directory contains system cron jobs that need to run on a daily basis.

## Rationale
Granting write access to this directory could provide unprivileged users with the ability to gain elevated privileges, and granting read access would allow users to view scripts that may contain sensitive information.

## Audit
Run the following command to verify permissions on /etc/cron.daily:
```bash
stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/cron.daily
```
Expected output should show ownership as root:root and permissions as 700 or more restrictive.

## Remediation
Run the following commands to set permissions on /etc/cron.daily:
```bash
chown root:root /etc/cron.daily
chmod 700 /etc/cron.daily
```
