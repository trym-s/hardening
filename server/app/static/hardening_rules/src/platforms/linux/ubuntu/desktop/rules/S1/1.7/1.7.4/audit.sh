#!/bin/bash
# CIS Benchmark 1.7.4 - Ensure GDM screen locks when the user is idle
# Audit Script

# Configuration thresholds
MAX_LOCK_DELAY=5      # Maximum lock-delay in seconds (5 or less)
MAX_IDLE_DELAY=900    # Maximum idle-delay in seconds (900 or less, not 0)

audit_passed=true

echo "Checking GDM screen lock configuration..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      This check is not applicable if GDM is not installed"
    echo ""
    echo "AUDIT RESULT: PASS - GDM is not installed (not applicable)"
    exit 0
fi

echo "GDM is installed, checking screen lock configuration..."

# Check dconf database configuration (machine-wide settings)
dconf_profile="/etc/dconf/profile/user"
screensaver_config="/etc/dconf/db/local.d/00-screensaver"

echo ""
echo "Checking dconf configuration..."

# Check if dconf profile exists
if [ -f "$dconf_profile" ]; then
    echo "PASS: dconf profile exists at $dconf_profile"
else
    echo "FAIL: dconf profile does not exist at $dconf_profile"
    audit_passed=false
fi

# Check if screensaver configuration file exists
if [ -f "$screensaver_config" ]; then
    echo "PASS: Screensaver configuration file exists at $screensaver_config"
    
    # Check idle-delay setting
    idle_delay=$(grep -Po '^\s*idle-delay\s*=\s*uint32\s+\K\d+' "$screensaver_config" 2>/dev/null)
    if [ -n "$idle_delay" ]; then
        if [ "$idle_delay" -eq 0 ]; then
            echo "FAIL: idle-delay is set to 0 (disabled)"
            audit_passed=false
        elif [ "$idle_delay" -le "$MAX_IDLE_DELAY" ]; then
            echo "PASS: idle-delay is set to $idle_delay seconds (within $MAX_IDLE_DELAY limit)"
        else
            echo "FAIL: idle-delay is set to $idle_delay seconds (exceeds $MAX_IDLE_DELAY limit)"
            audit_passed=false
        fi
    else
        echo "FAIL: idle-delay is not configured"
        audit_passed=false
    fi
    
    # Check lock-delay setting
    lock_delay=$(grep -Po '^\s*lock-delay\s*=\s*uint32\s+\K\d+' "$screensaver_config" 2>/dev/null)
    if [ -n "$lock_delay" ]; then
        if [ "$lock_delay" -le "$MAX_LOCK_DELAY" ]; then
            echo "PASS: lock-delay is set to $lock_delay seconds (within $MAX_LOCK_DELAY limit)"
        else
            echo "FAIL: lock-delay is set to $lock_delay seconds (exceeds $MAX_LOCK_DELAY limit)"
            audit_passed=false
        fi
    else
        echo "FAIL: lock-delay is not configured"
        audit_passed=false
    fi
else
    echo "FAIL: Screensaver configuration file does not exist at $screensaver_config"
    audit_passed=false
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - GDM screen locks when the user is idle"
    exit 0
else
    echo "AUDIT RESULT: FAIL - GDM screen lock is not properly configured"
    exit 1
fi
