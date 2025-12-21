#!/bin/bash
# CIS Benchmark 1.7.2 - Ensure GDM login banner is configured
# Audit Script

audit_passed=true

echo "Checking GDM login banner configuration..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      This check is not applicable if GDM is not installed"
    echo ""
    echo "AUDIT RESULT: PASS - GDM is not installed (not applicable)"
    exit 0
fi

echo "GDM is installed, checking banner configuration..."

# Check dconf database configuration (machine-wide settings)
dconf_profile="/etc/dconf/profile/gdm"
banner_config="/etc/dconf/db/gdm.d/01-banner-message"

echo ""
echo "Checking dconf configuration..."

# Check if dconf profile exists
if [ -f "$dconf_profile" ]; then
    echo "PASS: dconf profile exists at $dconf_profile"
else
    echo "FAIL: dconf profile does not exist at $dconf_profile"
    audit_passed=false
fi

# Check if banner configuration file exists
if [ -f "$banner_config" ]; then
    echo "PASS: Banner configuration file exists at $banner_config"
    
    # Check banner-message-enable
    if grep -Pq '^\s*banner-message-enable\s*=\s*true' "$banner_config"; then
        echo "PASS: banner-message-enable is set to true"
    else
        echo "FAIL: banner-message-enable is not set to true"
        audit_passed=false
    fi
    
    # Check banner-message-text
    if grep -Pq '^\s*banner-message-text\s*=' "$banner_config"; then
        banner_text=$(grep -P '^\s*banner-message-text\s*=' "$banner_config")
        echo "PASS: banner-message-text is configured"
        echo "      Current value: $banner_text"
    else
        echo "FAIL: banner-message-text is not configured"
        audit_passed=false
    fi
else
    echo "FAIL: Banner configuration file does not exist at $banner_config"
    audit_passed=false
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - GDM login banner is configured properly"
    exit 0
else
    echo "AUDIT RESULT: FAIL - GDM login banner is not configured properly"
    exit 1
fi
