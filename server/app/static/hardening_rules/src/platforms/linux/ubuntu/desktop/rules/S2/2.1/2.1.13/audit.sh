#!/bin/bash
# CIS Benchmark 2.1.13 - Ensure rsync services are not in use
audit_passed=true
echo "Checking rsync services..."

if dpkg-query -W -f='${db:Status-Status}' rsync 2>/dev/null | grep -q "installed"; then
    echo "FAIL: rsync package is installed"; audit_passed=false
else
    echo "PASS: rsync package is not installed"
fi

if systemctl is-enabled rsync.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: rsync.service is enabled"; audit_passed=false
else
    echo "PASS: rsync.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
