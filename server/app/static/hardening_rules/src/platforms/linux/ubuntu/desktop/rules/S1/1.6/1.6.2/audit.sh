#!/bin/bash
# CIS Benchmark 1.6.2 - Ensure local login warning banner is configured properly
# Audit Script

audit_passed=true

echo "Checking /etc/issue configuration..."

# Check if /etc/issue exists
if [ -f /etc/issue ]; then
    echo "INFO: /etc/issue exists"
    echo ""
    echo "Current /etc/issue contents:"
    echo "----------------------------"
    cat /etc/issue
    echo "----------------------------"
    echo ""
    
    # Get OS ID for checking
    os_id=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | sed -e 's/"//g')
    
    # Check for prohibited content (OS info disclosure)
    echo "Checking for prohibited content..."
    
    # Build the pattern
    pattern="(\\\\v|\\\\r|\\\\m|\\\\s"
    if [ -n "$os_id" ]; then
        pattern="${pattern}|${os_id}"
    fi
    pattern="${pattern})"
    
    if grep -E -i "$pattern" /etc/issue &>/dev/null; then
        echo "FAIL: /etc/issue contains OS information that should be removed"
        echo "Found matches:"
        grep -E -i "$pattern" /etc/issue
        audit_passed=false
    else
        echo "PASS: /etc/issue does not contain prohibited OS information"
    fi
else
    echo "FAIL: /etc/issue does not exist - a warning banner should be configured"
    audit_passed=false
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - Local login warning banner is configured properly"
    exit 0
else
    echo "AUDIT RESULT: FAIL - Local login warning banner is not configured properly"
    exit 1
fi
