#!/bin/bash
# CIS Benchmark 1.7.1 - Ensure GDM is removed
# Audit Script

echo "Checking if GDM (gdm3) is installed..."

# Check if gdm3 is installed
gdm_status=$(dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null)

if [ "$gdm_status" = "installed" ]; then
    echo "FAIL: gdm3 is installed"
    echo ""
    echo "Package status:"
    dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' gdm3
    echo ""
    echo "AUDIT RESULT: FAIL - GDM (gdm3) is installed and should be removed"
    exit 1
else
    echo "PASS: gdm3 is not installed"
    echo ""
    echo "AUDIT RESULT: PASS - GDM (gdm3) is not installed"
    exit 0
fi
