#!/bin/bash
# CIS 4.2.2 Ensure iptables-persistent is not installed with ufw

echo "Checking if iptables-persistent is installed..."

if dpkg -l iptables-persistent 2>/dev/null | grep -q "^ii"; then
    echo "FAIL: iptables-persistent is installed (conflicts with ufw)"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
else
    echo "PASS: iptables-persistent is not installed"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
fi
