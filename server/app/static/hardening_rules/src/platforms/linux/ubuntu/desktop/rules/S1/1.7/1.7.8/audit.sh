#!/bin/bash
# CIS Benchmark 1.7.8 - Ensure GDM autorun-never is enabled
# Audit Script

audit_passed=true

echo "Checking GDM autorun-never configuration..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      This check is not applicable if GDM is not installed"
    echo ""
    echo "AUDIT RESULT: PASS - GDM is not installed (not applicable)"
    exit 0
fi

echo "GDM is installed, checking autorun-never configuration..."

# Check dconf database configuration (machine-wide settings)
autorun_config="/etc/dconf/db/local.d/00-media-autorun"

echo ""
echo "Checking dconf configuration..."

# Check if autorun configuration file exists
if [ -f "$autorun_config" ]; then
    echo "PASS: Autorun configuration file exists at $autorun_config"
    
    # Check autorun-never setting
    if grep -Pq '^\s*autorun-never\s*=\s*true' "$autorun_config"; then
        echo "PASS: autorun-never is set to true"
    else
        echo "FAIL: autorun-never is not set to true"
        audit_passed=false
    fi
else
    echo "FAIL: Autorun configuration file does not exist at $autorun_config"
    audit_passed=false
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - GDM autorun-never is enabled"
    exit 0
else
    echo "AUDIT RESULT: FAIL - GDM autorun-never is not enabled"
    exit 1
fi
