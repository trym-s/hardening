#!/bin/bash
# CIS Benchmark 1.6.1 - Ensure message of the day is configured properly
# Audit Script

audit_passed=true

echo "Checking /etc/motd configuration..."

# Check if /etc/motd exists
if [ -f /etc/motd ]; then
    echo "INFO: /etc/motd exists"
    echo ""
    echo "Current /etc/motd contents:"
    echo "----------------------------"
    cat /etc/motd
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
    
    if grep -E -i "$pattern" /etc/motd &>/dev/null; then
        echo "FAIL: /etc/motd contains OS information that should be removed"
        echo "Found matches:"
        grep -E -i "$pattern" /etc/motd
        audit_passed=false
    else
        echo "PASS: /etc/motd does not contain prohibited OS information"
    fi
else
    echo "INFO: /etc/motd does not exist (this is acceptable)"
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - Message of the day is configured properly"
    exit 0
else
    echo "AUDIT RESULT: FAIL - Message of the day contains prohibited content"
    exit 1
fi
