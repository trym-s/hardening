#!/bin/bash

# 6.1.3.4 Ensure rsyslog log file creation mode is configured (Automated)

echo "Checking rsyslog log file creation mode configuration..."

# Check FileCreateMode setting
file_mode=$(grep -E '^\$FileCreateMode' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null)

echo "FileCreateMode settings found:"
echo "$file_mode"

if echo "$file_mode" | grep -q '0[0-6][0-4]0'; then
    echo "PASS: rsyslog log file creation mode is configured appropriately (0640 or more restrictive)"
    exit 0
else
    echo "FAIL: rsyslog log file creation mode is not configured appropriately"
    echo "Expected: 0640 or more restrictive"
    exit 1
fi
