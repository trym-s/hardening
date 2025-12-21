#!/bin/bash
# CIS Benchmark 1.7.10 - Ensure XDMCP is not enabled
# Audit Script

audit_passed=true

echo "Checking XDMCP configuration..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      This check is not applicable if GDM is not installed"
    echo ""
    echo "AUDIT RESULT: PASS - GDM is not installed (not applicable)"
    exit 0
fi

echo "GDM is installed, checking XDMCP configuration..."
echo ""

# Check for XDMCP enabled in GDM configuration files
xdmcp_enabled=false

for config_file in /etc/gdm3/custom.conf /etc/gdm3/daemon.conf /etc/gdm/custom.conf /etc/gdm/daemon.conf; do
    if [ -f "$config_file" ]; then
        # Check if [xdmcp] block exists and Enable=true is set
        result=$(awk '/\[xdmcp\]/{ f = 1;next } /\[/{ f = 0 } f {if (/^\s*Enable\s*=\s*true/) print $0}' "$config_file" 2>/dev/null)
        
        if [ -n "$result" ]; then
            echo "FAIL: XDMCP is enabled in $config_file"
            echo "      Found: $result"
            xdmcp_enabled=true
            audit_passed=false
        fi
    fi
done

if [ "$xdmcp_enabled" = false ]; then
    echo "PASS: XDMCP is not enabled in any GDM configuration file"
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - XDMCP is not enabled"
    exit 0
else
    echo "AUDIT RESULT: FAIL - XDMCP is enabled and should be disabled"
    exit 1
fi
