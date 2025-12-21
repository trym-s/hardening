#!/bin/bash
# CIS 4.2.4 Ensure ufw loopback traffic is configured

echo "Checking ufw loopback configuration..."

FAIL=0

# Check for loopback rules
UFW_STATUS=$(ufw status verbose 2>/dev/null)

# Check if lo interface is allowed
if echo "$UFW_STATUS" | grep -qE "Anywhere on lo\s+ALLOW IN"; then
    echo "PASS: Loopback incoming allowed"
else
    echo "FAIL: Loopback incoming not configured"
    FAIL=1
fi

# Check if 127.0.0.0/8 is denied from other interfaces
if echo "$UFW_STATUS" | grep -qE "DENY IN\s+127\.0\.0\.0/8"; then
    echo "PASS: 127.0.0.0/8 denied from non-loopback"
else
    echo "WARNING: 127.0.0.0/8 deny rule may not be configured"
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
