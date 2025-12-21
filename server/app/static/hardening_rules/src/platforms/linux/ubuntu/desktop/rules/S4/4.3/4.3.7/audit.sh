#!/bin/bash
# CIS 4.3.7 Ensure nftables outbound and established connections are configured

echo "Checking nftables connection tracking..."

RULESET=$(nft list ruleset 2>/dev/null)

if echo "$RULESET" | grep -q "ct state"; then
    echo "PASS: Connection tracking rules found"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo "FAIL: No connection tracking rules found"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
