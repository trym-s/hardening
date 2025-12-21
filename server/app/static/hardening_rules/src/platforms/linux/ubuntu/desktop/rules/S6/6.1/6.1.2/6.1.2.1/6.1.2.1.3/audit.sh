#!/bin/bash

# 6.1.2.1.3 Ensure systemd-journal-upload is enabled and active (Automated)

echo "Checking if systemd-journal-upload service is enabled and active..."

# Check if journal-upload is enabled
enabled=$(systemctl is-enabled systemd-journal-upload.service 2>/dev/null)
# Check if journal-upload is active
active=$(systemctl is-active systemd-journal-upload.service 2>/dev/null)

echo "Enabled: $enabled"
echo "Active: $active"

if [ "$enabled" = "enabled" ]; then
    if [ "$active" = "active" ]; then
        echo "PASS: systemd-journal-upload service is enabled and active"
        exit 0
    else
        echo "FAIL: systemd-journal-upload service is enabled but not active"
        exit 1
    fi
else
    echo "FAIL: systemd-journal-upload service is not enabled"
    exit 1
fi
