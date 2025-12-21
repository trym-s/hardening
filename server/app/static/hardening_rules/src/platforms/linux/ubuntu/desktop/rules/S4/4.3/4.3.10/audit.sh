#!/bin/bash
# CIS 4.3.10 Ensure nftables rules are permanent

echo "Checking nftables persistence..."

if [ -f /etc/nftables.conf ]; then
    if grep -q "table" /etc/nftables.conf; then
        echo "PASS: nftables.conf exists with rules"
        echo ""
        echo "AUDIT RESULT: PASS"
        exit 0
    else
        echo "WARNING: nftables.conf exists but may be empty"
        echo ""
        echo "AUDIT RESULT: MANUAL - Review /etc/nftables.conf"
        exit 0
    fi
else
    echo "FAIL: /etc/nftables.conf does not exist"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
