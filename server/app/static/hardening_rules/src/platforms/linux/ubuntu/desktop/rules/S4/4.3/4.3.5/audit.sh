#!/bin/bash
# CIS 4.3.5 Ensure nftables base chains exist

echo "Checking nftables base chains..."

FAIL=0
RULESET=$(nft list ruleset 2>/dev/null)

for hook in input forward output; do
    if echo "$RULESET" | grep -q "hook $hook"; then
        echo "PASS: $hook chain exists"
    else
        echo "FAIL: $hook chain not found"
        FAIL=1
    fi
done

if [ "$FAIL" -eq 0 ]; then
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
