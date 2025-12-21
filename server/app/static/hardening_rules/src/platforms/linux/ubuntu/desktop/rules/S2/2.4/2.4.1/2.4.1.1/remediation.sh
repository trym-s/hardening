#!/bin/bash
# CIS 2.4.1.1 Ensure cron daemon is enabled and active

echo "Applying remediation for CIS 2.4.1.1..."

# Unmask cron in case it's masked
systemctl unmask cron 2>/dev/null

# Enable cron
if systemctl enable cron 2>/dev/null; then
    echo "cron service enabled"
else
    echo "Failed to enable cron service"
fi

# Start cron
if systemctl start cron 2>/dev/null; then
    echo "cron service started"
else
    echo "Failed to start cron service"
fi

echo "Remediation complete for CIS 2.4.1.1"
