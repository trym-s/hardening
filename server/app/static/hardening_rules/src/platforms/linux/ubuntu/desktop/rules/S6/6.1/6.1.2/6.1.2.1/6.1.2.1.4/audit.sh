#!/bin/bash

# 6.1.2.1.4 Ensure systemd-journal-remote service is not in use (Automated)

echo "Checking if systemd-journal-remote service is not in use..."

# Check if journal-remote is active
active=$(systemctl is-active systemd-journal-remote.service 2>/dev/null)
# Check if journal-remote is enabled
enabled=$(systemctl is-enabled systemd-journal-remote.service 2>/dev/null)

echo "Active: $active"
echo "Enabled: $enabled"

if [ "$active" = "inactive" ] || [ "$active" = "failed" ]; then
    if [ "$enabled" = "disabled" ] || [ "$enabled" = "masked" ]; then
        echo "PASS: systemd-journal-remote service is not in use"
        exit 0
    else
        echo "FAIL: systemd-journal-remote service is not active but is enabled"
        exit 1
    fi
else
    echo "FAIL: systemd-journal-remote service is active"
    exit 1
fi
