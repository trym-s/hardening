#!/bin/bash
# CIS 4.3.8 Ensure nftables default deny firewall policy

echo "Checking nftables default policies..."

RULESET=$(nft list ruleset 2>/dev/null)

INPUT_DROP=$(echo "$RULESET" | grep -c "chain input.*policy drop")
FORWARD_DROP=$(echo "$RULESET" | grep -c "chain forward.*policy drop")

if [ "$INPUT_DROP" -gt 0 ] && [ "$FORWARD_DROP" -gt 0 ]; then
    echo "PASS: Default deny policy is configured"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo "WARNING: Default deny may not be configured for all chains"
    echo ""
    echo "AUDIT RESULT: MANUAL - Review nftables policies"
    exit 0
fi
