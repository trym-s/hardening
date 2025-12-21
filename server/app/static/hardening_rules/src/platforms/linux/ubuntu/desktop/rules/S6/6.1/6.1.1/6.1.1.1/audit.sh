#!/bin/bash

# 6.1.1.1 Ensure journald service is enabled and active (Automated)

echo "Checking if systemd-journald service is enabled and active..."

# Check if journald is enabled
enabled=$(systemctl is-enabled systemd-journald.service 2>/dev/null)
# Check if journald is active
active=$(systemctl is-active systemd-journald.service 2>/dev/null)

if [ "$enabled" = "static" ] || [ "$enabled" = "enabled" ]; then
    if [ "$active" = "active" ]; then
        echo "PASS: systemd-journald service is enabled and active"
        exit 0
    else
        echo "FAIL: systemd-journald service is enabled but not active"
        echo "  Status: $active"
        exit 1
    fi
else
    echo "FAIL: systemd-journald service is not enabled"
    echo "  Enabled: $enabled"
    echo "  Active: $active"
    exit 1
fi
