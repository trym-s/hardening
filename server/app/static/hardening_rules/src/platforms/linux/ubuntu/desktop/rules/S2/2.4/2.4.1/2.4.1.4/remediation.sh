#!/bin/bash
# CIS 2.4.1.4 Ensure permissions on /etc/cron.daily are configured

echo "Applying remediation for CIS 2.4.1.4..."

if [ -d /etc/cron.daily ]; then
    chown root:root /etc/cron.daily
    chmod 700 /etc/cron.daily
    echo "/etc/cron.daily permissions set to 700, owned by root:root"
else
    echo "/etc/cron.daily does not exist - no action needed"
fi

echo "Remediation complete for CIS 2.4.1.4"
