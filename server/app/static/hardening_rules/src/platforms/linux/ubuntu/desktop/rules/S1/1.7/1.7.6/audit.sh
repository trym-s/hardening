#!/bin/bash
# CIS Benchmark 1.7.6 - Ensure GDM automatic mounting of removable media is disabled
# Audit Script

audit_passed=true

echo "Checking GDM automatic mounting configuration..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      This check is not applicable if GDM is not installed"
    echo ""
    echo "AUDIT RESULT: PASS - GDM is not installed (not applicable)"
    exit 0
fi

echo "GDM is installed, checking automatic mounting configuration..."

# Check dconf database configuration (machine-wide settings)
automount_config="/etc/dconf/db/local.d/00-media-automount"

echo ""
echo "Checking dconf configuration..."

# Check if automount configuration file exists
if [ -f "$automount_config" ]; then
    echo "PASS: Automount configuration file exists at $automount_config"
    
    # Check automount setting
    if grep -Pq '^\s*automount\s*=\s*false' "$automount_config"; then
        echo "PASS: automount is set to false"
    else
        echo "FAIL: automount is not set to false"
        audit_passed=false
    fi
    
    # Check automount-open setting
    if grep -Pq '^\s*automount-open\s*=\s*false' "$automount_config"; then
        echo "PASS: automount-open is set to false"
    else
        echo "FAIL: automount-open is not set to false"
        audit_passed=false
    fi
else
    echo "FAIL: Automount configuration file does not exist at $automount_config"
    audit_passed=false
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - GDM automatic mounting of removable media is disabled"
    exit 0
else
    echo "AUDIT RESULT: FAIL - GDM automatic mounting is not properly disabled"
    exit 1
fi
