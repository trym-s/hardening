#!/bin/bash
# CIS Benchmark 2.3.1 - Ensure time synchronization is in use
audit_passed=false
echo "Checking time synchronization..."

# Check if systemd-timesyncd is enabled
timesyncd_status=$(systemctl is-enabled systemd-timesyncd.service 2>/dev/null)
if [ "$timesyncd_status" = "enabled" ]; then
    echo "PASS: systemd-timesyncd.service is enabled"
    audit_passed=true
fi

# Check if chrony is enabled
chrony_status=$(systemctl is-enabled chrony.service 2>/dev/null)
if [ "$chrony_status" = "enabled" ]; then
    echo "PASS: chrony.service is enabled"
    audit_passed=true
fi

# Check if ntp is enabled
ntp_status=$(systemctl is-enabled ntp.service 2>/dev/null)
if [ "$ntp_status" = "enabled" ]; then
    echo "PASS: ntp.service is enabled"
    audit_passed=true
fi

if [ "$audit_passed" = false ]; then
    echo "FAIL: No time synchronization service is enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
