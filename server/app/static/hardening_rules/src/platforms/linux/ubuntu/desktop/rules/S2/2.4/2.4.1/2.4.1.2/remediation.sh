#!/bin/bash
# CIS 2.4.1.2 Ensure permissions on /etc/crontab are configured

echo "Applying remediation for CIS 2.4.1.2..."

if [ -f /etc/crontab ]; then
    chown root:root /etc/crontab
    chmod 600 /etc/crontab
    echo "/etc/crontab permissions set to 600, owned by root:root"
else
    echo "/etc/crontab does not exist - no action needed"
fi

echo "Remediation complete for CIS 2.4.1.2"
