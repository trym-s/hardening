#!/bin/bash
# CIS 2.4.1.5 Ensure permissions on /etc/cron.weekly are configured

echo "Applying remediation for CIS 2.4.1.5..."

if [ -d /etc/cron.weekly ]; then
    chown root:root /etc/cron.weekly
    chmod 700 /etc/cron.weekly
    echo "/etc/cron.weekly permissions set to 700, owned by root:root"
else
    echo "/etc/cron.weekly does not exist - no action needed"
fi

echo "Remediation complete for CIS 2.4.1.5"
