#!/bin/bash
# CIS Benchmark 1.7.3 - Ensure GDM disable-user-list option is enabled
# Audit Script

audit_passed=true

echo "Checking GDM disable-user-list configuration..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      This check is not applicable if GDM is not installed"
    echo ""
    echo "AUDIT RESULT: PASS - GDM is not installed (not applicable)"
    exit 0
fi

echo "GDM is installed, checking disable-user-list configuration..."

# Check dconf database configuration (machine-wide settings)
dconf_profile="/etc/dconf/profile/gdm"
login_screen_config="/etc/dconf/db/gdm.d/00-login-screen"

echo ""
echo "Checking dconf configuration..."

# Check if dconf profile exists
if [ -f "$dconf_profile" ]; then
    echo "PASS: dconf profile exists at $dconf_profile"
else
    echo "FAIL: dconf profile does not exist at $dconf_profile"
    audit_passed=false
fi

# Check if login-screen configuration file exists
if [ -f "$login_screen_config" ]; then
    echo "PASS: Login screen configuration file exists at $login_screen_config"
    
    # Check disable-user-list setting
    if grep -Pq '^\s*disable-user-list\s*=\s*true' "$login_screen_config"; then
        echo "PASS: disable-user-list is set to true"
    else
        echo "FAIL: disable-user-list is not set to true"
        audit_passed=false
    fi
else
    echo "FAIL: Login screen configuration file does not exist at $login_screen_config"
    audit_passed=false
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - GDM disable-user-list option is enabled"
    exit 0
else
    echo "AUDIT RESULT: FAIL - GDM disable-user-list option is not enabled"
    exit 1
fi
