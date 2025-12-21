#!/bin/bash
# CIS 2.4.1.7 Ensure permissions on /etc/cron.d are configured

echo "Applying remediation for CIS 2.4.1.7..."

if [ -d /etc/cron.d ]; then
    chown root:root /etc/cron.d
    chmod 700 /etc/cron.d
    echo "/etc/cron.d permissions set to 700, owned by root:root"
else
    echo "/etc/cron.d does not exist - no action needed"
fi

echo "Remediation complete for CIS 2.4.1.7"
