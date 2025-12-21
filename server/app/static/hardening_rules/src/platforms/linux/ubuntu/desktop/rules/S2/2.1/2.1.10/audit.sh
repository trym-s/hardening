#!/bin/bash
# CIS Benchmark 2.1.10 - Ensure nis server services are not in use
audit_passed=true
echo "Checking NIS server services..."

if dpkg-query -W -f='${db:Status-Status}' nis 2>/dev/null | grep -q "installed"; then
    echo "FAIL: nis package is installed"; audit_passed=false
else
    echo "PASS: nis package is not installed"
fi

if systemctl is-enabled ypserv.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: ypserv.service is enabled"; audit_passed=false
else
    echo "PASS: ypserv.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
