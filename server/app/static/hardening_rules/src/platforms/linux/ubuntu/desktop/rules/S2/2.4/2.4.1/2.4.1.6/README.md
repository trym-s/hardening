# 2.4.1.6 Ensure permissions on /etc/cron.monthly are configured (Automated)

## Description
The /etc/cron.monthly directory contains system cron jobs that need to run on a monthly basis.

## Rationale
Granting write access to this directory could provide unprivileged users with the ability to gain elevated privileges, and granting read access would allow users to view scripts that may contain sensitive information.

## Audit
Run the following command to verify permissions on /etc/cron.monthly:
```bash
stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/cron.monthly
```
Expected output should show ownership as root:root and permissions as 700 or more restrictive.

## Remediation
Run the following commands to set permissions on /etc/cron.monthly:
```bash
chown root:root /etc/cron.monthly
chmod 700 /etc/cron.monthly
```
