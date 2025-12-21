#!/bin/bash

# CIS 1.2.2.1 - Ensure updates, patches, and additional security software are installed (Manual)
# This script checks for available updates and patches

echo "Checking for available updates and patches..."
echo ""

# Update package lists
echo "==================================================================="
echo "Updating package lists..."
echo "==================================================================="
apt update 2>&1 | tail -20
echo ""

# Check for available upgrades (simulation mode)
echo "==================================================================="
echo "Checking for available upgrades (simulation mode)..."
echo "==================================================================="
echo ""

upgrade_output=$(apt -s upgrade 2>&1)
echo "$upgrade_output"
echo ""

# Count packages that can be upgraded
upgradable_count=$(echo "$upgrade_output" | grep -E "^[0-9]+ upgraded" | awk '{print $1}')

if [ -z "$upgradable_count" ]; then
    upgradable_count=0
fi

echo "==================================================================="
echo "Summary:"
echo "==================================================================="

if [ "$upgradable_count" -eq 0 ]; then
    echo "✓ No updates or patches available"
    echo "  System is up to date"
    echo ""
    exit 0
else
    echo "⚠ $upgradable_count package(s) can be upgraded"
    echo ""
    echo "MANUAL REVIEW REQUIRED:"
    echo "  - Review the list of available updates above"
    echo "  - Verify updates comply with site policy"
    echo "  - Test updates if required by organizational policy"
    echo "  - Schedule installation according to change management procedures"
    echo ""
    exit 1
fi
