#!/bin/bash
# CIS Benchmark 1.5.5 - Ensure Automatic Error Reporting is not enabled
# Audit Script

audit_passed=true

echo "Checking Apport Error Reporting Service..."

# Check 1: Verify apport is not installed or not enabled
echo "Checking if apport is installed and enabled..."
if dpkg-query -s apport &>/dev/null; then
    echo "INFO: apport package is installed"
    
    # Check if enabled in /etc/default/apport
    if [ -f /etc/default/apport ]; then
        if grep -Pqi -- '^\h*enabled\h*=\h*[^0]\b' /etc/default/apport; then
            echo "FAIL: Apport is enabled in /etc/default/apport"
            audit_passed=false
        else
            echo "PASS: Apport is disabled in /etc/default/apport (enabled=0 or not set)"
        fi
    else
        echo "INFO: /etc/default/apport does not exist"
    fi
else
    echo "PASS: apport package is not installed"
fi

# Check 2: Verify apport service is not active
echo "Checking if apport service is active..."
if systemctl is-active apport.service 2>/dev/null | grep -q '^active'; then
    echo "FAIL: apport.service is active"
    audit_passed=false
else
    echo "PASS: apport.service is not active"
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - Automatic Error Reporting is not enabled"
    exit 0
else
    echo "AUDIT RESULT: FAIL - Automatic Error Reporting is enabled"
    exit 1
fi
