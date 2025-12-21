#!/bin/bash
# CIS 4.3.1 Ensure nftables is installed

echo "Checking if nftables is installed..."

if dpkg -l nftables 2>/dev/null | grep -q "^ii"; then
    echo "PASS: nftables is installed"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo "FAIL: nftables is not installed"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
