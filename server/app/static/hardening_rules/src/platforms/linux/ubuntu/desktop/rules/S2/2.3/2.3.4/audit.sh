#!/bin/bash
# CIS Benchmark 2.3.4 - Ensure ntp is configured with authorized timeserver
audit_passed=true
echo "Checking ntp configuration..."

# Check if ntp is in use
ntp_status=$(systemctl is-enabled ntp.service 2>/dev/null)
if [ "$ntp_status" != "enabled" ]; then
    echo "INFO: ntp is not enabled, skipping check"
    echo "AUDIT RESULT: PASS - Not applicable"
    exit 0
fi

# Check if NTP servers are configured
config_file="/etc/ntp.conf"
if [ -f "$config_file" ]; then
    if grep -Eq "^(server|pool)" "$config_file" 2>/dev/null; then
        echo "PASS: NTP servers configured in $config_file"
        grep -E "^(server|pool)" "$config_file"
    else
        echo "FAIL: No NTP servers configured in $config_file"
        audit_passed=false
    fi
else
    echo "FAIL: $config_file does not exist"
    audit_passed=false
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
