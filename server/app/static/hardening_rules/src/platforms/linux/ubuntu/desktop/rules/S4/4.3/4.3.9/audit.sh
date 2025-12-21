#!/bin/bash
# CIS 4.3.9 Ensure nftables service is enabled

echo "Checking nftables service status..."

if systemctl is-enabled nftables.service 2>/dev/null | grep -q "enabled"; then
    echo "PASS: nftables.service is enabled"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo "FAIL: nftables.service is not enabled"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
