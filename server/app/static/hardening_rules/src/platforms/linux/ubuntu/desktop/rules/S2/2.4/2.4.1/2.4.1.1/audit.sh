#!/bin/bash
# CIS 2.4.1.1 Ensure cron daemon is enabled and active

echo "Checking cron daemon status..."

FAIL=0

# Check if cron is enabled
if systemctl is-enabled cron 2>/dev/null | grep -q 'enabled'; then
    echo "PASS: cron is enabled"
else
    echo "FAIL: cron is not enabled"
    FAIL=1
fi

# Check if cron is active
if systemctl is-active cron 2>/dev/null | grep -q '^active'; then
    echo "PASS: cron is active"
else
    echo "FAIL: cron is not active"
    FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
