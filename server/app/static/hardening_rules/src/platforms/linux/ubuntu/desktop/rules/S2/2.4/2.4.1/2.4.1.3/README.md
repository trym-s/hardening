# 2.4.1.3 Ensure permissions on /etc/cron.hourly are configured (Automated)

## Description
The /etc/cron.hourly directory contains system cron jobs that need to run on an hourly basis.

## Rationale
Granting write access to this directory could provide unprivileged users with the ability to gain elevated privileges, and granting read access would allow users to view scripts that may contain sensitive information.

## Audit
Run the following command to verify permissions on /etc/cron.hourly:
```bash
stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/cron.hourly
```
Expected output should show ownership as root:root and permissions as 700 or more restrictive.

## Remediation
Run the following commands to set permissions on /etc/cron.hourly:
```bash
chown root:root /etc/cron.hourly
chmod 700 /etc/cron.hourly
```
