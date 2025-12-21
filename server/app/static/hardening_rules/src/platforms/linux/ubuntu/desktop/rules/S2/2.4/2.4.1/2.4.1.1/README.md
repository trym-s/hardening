# 2.4.1.1 Ensure cron daemon is enabled and active (Automated)

## Description
The cron daemon is used to execute batch jobs on the system.

## Rationale
The cron daemon is used to automate system maintenance and administration. It is the primary method for scheduling background tasks. If the cron daemon is not running, scheduled jobs will not execute, which could impact security updates and system maintenance tasks.

## Audit
Run the following command to verify cron is enabled and active:
```bash
systemctl is-enabled cron
systemctl is-active cron
```
Both commands should return `enabled` and `active` respectively.

## Remediation
Run the following commands to enable and start cron:
```bash
systemctl unmask cron
systemctl enable cron
systemctl start cron
```
