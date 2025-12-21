#!/bin/bash

# 6.1.2.3 Ensure journald Compress is configured (Automated)

echo "Checking journald Compress configuration..."

# Check Compress setting
compress=$(grep -E "^Compress=" /etc/systemd/journald.conf 2>/dev/null)

echo "Compress: ${compress:-Not configured (default: yes)}"

if [ -z "$compress" ] || echo "$compress" | grep -qi "yes"; then
    echo "PASS: Compress is enabled or not configured (default is yes)"
    exit 0
else
    echo "FAIL: Compress is disabled"
    exit 1
fi
