#!/bin/bash
# CIS 4.2.1 Ensure ufw is installed

echo "Checking if ufw is installed..."

if dpkg -l ufw 2>/dev/null | grep -q "^ii"; then
    echo "PASS: ufw is installed"
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo "FAIL: ufw is not installed"
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
