#!/bin/bash
# CIS Benchmark 2.1.20 - Ensure xinetd services are not in use
audit_passed=true
echo "Checking xinetd services..."

if dpkg-query -W -f='${db:Status-Status}' xinetd 2>/dev/null | grep -q "installed"; then
    echo "FAIL: xinetd package is installed"; audit_passed=false
else
    echo "PASS: xinetd package is not installed"
fi

if systemctl is-enabled xinetd.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: xinetd.service is enabled"; audit_passed=false
else
    echo "PASS: xinetd.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
