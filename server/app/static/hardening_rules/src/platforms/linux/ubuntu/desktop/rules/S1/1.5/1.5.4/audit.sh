#!/bin/bash
# CIS Benchmark 1.5.4 - Ensure prelink is not installed
# Audit Script

echo "Checking if prelink is installed..."

if dpkg-query -s prelink &>/dev/null; then
    echo "FAIL: prelink is installed"
    echo ""
    echo "AUDIT RESULT: FAIL - prelink should not be installed"
    exit 1
else
    echo "PASS: prelink is not installed"
    echo ""
    echo "AUDIT RESULT: PASS - prelink is not installed"
    exit 0
fi
