#!/bin/bash
# CIS 4.3.2 Ensure ufw is uninstalled or disabled with nftables

echo "Checking if ufw is disabled..."

if ufw status 2>/dev/null | grep -q "Status: active"; then
    echo "FAIL: ufw is active (should be disabled when using nftables)"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
else
    echo "PASS: ufw is not active"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
fi
