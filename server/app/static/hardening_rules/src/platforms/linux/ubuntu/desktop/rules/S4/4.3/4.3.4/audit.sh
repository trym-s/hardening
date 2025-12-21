#!/bin/bash
# CIS 4.3.4 Ensure a nftables table exists

echo "Checking for nftables tables..."

TABLES=$(nft list tables 2>/dev/null)

if [ -n "$TABLES" ]; then
    echo "PASS: nftables tables exist:"
    echo "$TABLES"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo "FAIL: No nftables tables found"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
