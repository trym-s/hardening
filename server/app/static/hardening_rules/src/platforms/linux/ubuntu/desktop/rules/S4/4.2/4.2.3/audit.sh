#!/bin/bash
# CIS 4.2.3 Ensure ufw service is enabled

echo "Checking ufw service status..."

FAIL=0

# Check if service is enabled
if systemctl is-enabled ufw.service 2>/dev/null | grep -q "enabled"; then
    echo "PASS: ufw.service is enabled"
else
    echo "FAIL: ufw.service is not enabled"
    FAIL=1
fi

# Check if ufw is active
if ufw status 2>/dev/null | grep -q "Status: active"; then
    echo "PASS: ufw is active"
else
    echo "FAIL: ufw is not active"
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
