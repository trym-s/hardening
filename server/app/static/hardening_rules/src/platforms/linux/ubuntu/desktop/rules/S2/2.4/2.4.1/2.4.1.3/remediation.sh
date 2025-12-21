#!/bin/bash
# CIS 2.4.1.3 Ensure permissions on /etc/cron.hourly are configured

echo "Applying remediation for CIS 2.4.1.3..."

if [ -d /etc/cron.hourly ]; then
    chown root:root /etc/cron.hourly
    chmod 700 /etc/cron.hourly
    echo "/etc/cron.hourly permissions set to 700, owned by root:root"
else
    echo "/etc/cron.hourly does not exist - no action needed"
fi

echo "Remediation complete for CIS 2.4.1.3"
