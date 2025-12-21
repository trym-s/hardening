#!/bin/bash

# 6.1.3.2 Ensure rsyslog service is enabled and active (Automated)

echo "Checking if rsyslog service is enabled and active..."

# Check if rsyslog is enabled
enabled=$(systemctl is-enabled rsyslog 2>/dev/null)
# Check if rsyslog is active
active=$(systemctl is-active rsyslog 2>/dev/null)

echo "Enabled: $enabled"
echo "Active: $active"

if [ "$enabled" = "enabled" ]; then
    if [ "$active" = "active" ]; then
        echo "PASS: rsyslog service is enabled and active"
        exit 0
    else
        echo "FAIL: rsyslog service is enabled but not active"
        exit 1
    fi
else
    echo "FAIL: rsyslog service is not enabled"
    exit 1
fi
