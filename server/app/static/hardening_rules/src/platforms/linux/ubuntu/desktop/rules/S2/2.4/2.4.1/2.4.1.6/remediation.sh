#!/bin/bash
# CIS 2.4.1.6 Ensure permissions on /etc/cron.monthly are configured

echo "Applying remediation for CIS 2.4.1.6..."

if [ -d /etc/cron.monthly ]; then
    chown root:root /etc/cron.monthly
    chmod 700 /etc/cron.monthly
    echo "/etc/cron.monthly permissions set to 700, owned by root:root"
else
    echo "/etc/cron.monthly does not exist - no action needed"
fi

echo "Remediation complete for CIS 2.4.1.6"
