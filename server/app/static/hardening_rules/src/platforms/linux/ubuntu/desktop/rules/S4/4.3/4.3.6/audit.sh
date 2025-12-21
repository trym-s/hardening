#!/bin/bash
# CIS 4.3.6 Ensure nftables loopback traffic is configured

echo "Checking nftables loopback configuration..."

RULESET=$(nft list ruleset 2>/dev/null)

if echo "$RULESET" | grep -q 'iif "lo"'; then
    echo "PASS: Loopback rule found"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo "FAIL: Loopback rule not found"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
