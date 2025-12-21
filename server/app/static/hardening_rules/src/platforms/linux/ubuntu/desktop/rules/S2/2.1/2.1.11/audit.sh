#!/bin/bash
# CIS Benchmark 2.1.11 - Ensure print server services are not in use
audit_passed=true
echo "Checking print server services..."

if dpkg-query -W -f='${db:Status-Status}' cups 2>/dev/null | grep -q "installed"; then
    echo "FAIL: cups package is installed"; audit_passed=false
else
    echo "PASS: cups package is not installed"
fi

if systemctl is-enabled cups.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: cups.service is enabled"; audit_passed=false
else
    echo "PASS: cups.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
