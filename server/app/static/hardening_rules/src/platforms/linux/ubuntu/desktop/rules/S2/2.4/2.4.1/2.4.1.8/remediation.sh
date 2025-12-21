#!/bin/bash
# CIS 2.4.1.8 Ensure crontab is restricted to authorized users

echo "Applying remediation for CIS 2.4.1.8..."

# Remove cron.deny if it exists
if [ -f /etc/cron.deny ]; then
    rm -f /etc/cron.deny
    echo "Removed /etc/cron.deny"
else
    echo "/etc/cron.deny does not exist - no removal needed"
fi

# Create cron.allow if it doesn't exist
if [ ! -f /etc/cron.allow ]; then
    touch /etc/cron.allow
    echo "Created /etc/cron.allow"
fi

# Set ownership and permissions on cron.allow
chown root:root /etc/cron.allow
chmod 640 /etc/cron.allow
echo "/etc/cron.allow permissions set to 640, owned by root:root"

# Add root to cron.allow if not already present
if ! grep -q "^root$" /etc/cron.allow 2>/dev/null; then
    echo "root" >> /etc/cron.allow
    echo "Added root to /etc/cron.allow"
fi

echo "Remediation complete for CIS 2.4.1.8"
echo "NOTE: Add other authorized users to /etc/cron.allow as needed"
