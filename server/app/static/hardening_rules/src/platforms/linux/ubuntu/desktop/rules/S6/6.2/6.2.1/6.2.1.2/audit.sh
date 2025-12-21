#!/bin/bash

# 6.2.1.2 Ensure auditd service is enabled and active (Automated)

echo "Checking if auditd service is enabled and active..."

# Check if auditd is enabled
enabled=$(systemctl is-enabled auditd 2>/dev/null)
# Check if auditd is active
active=$(systemctl is-active auditd 2>/dev/null)

echo "Enabled: $enabled"
echo "Active: $active"

if [ "$enabled" = "enabled" ]; then
    if [ "$active" = "active" ]; then
        echo "PASS: auditd service is enabled and active"
        exit 0
    else
        echo "FAIL: auditd service is enabled but not active"
        exit 1
    fi
else
    echo "FAIL: auditd service is not enabled"
    exit 1
fi
