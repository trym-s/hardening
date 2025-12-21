#!/bin/bash
# CIS Benchmark 2.1.2 - Ensure avahi daemon services are not in use
# Audit Script

audit_passed=true
echo "Checking avahi-daemon services..."

if dpkg-query -W -f='${db:Status-Status}' avahi-daemon 2>/dev/null | grep -q "installed"; then
    echo "FAIL: avahi-daemon package is installed"
    audit_passed=false
else
    echo "PASS: avahi-daemon package is not installed"
fi

if systemctl is-enabled avahi-daemon.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: avahi-daemon.service is enabled"
    audit_passed=false
else
    echo "PASS: avahi-daemon.service is not enabled"
fi

echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - avahi daemon services are not in use"
    exit 0
else
    echo "AUDIT RESULT: FAIL - avahi daemon services are in use"
    exit 1
fi
