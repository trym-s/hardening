#!/bin/bash
# CIS Benchmark 2.1.18 - Ensure web proxy server services are not in use
audit_passed=true
echo "Checking web proxy server services..."

if dpkg-query -W -f='${db:Status-Status}' squid 2>/dev/null | grep -q "installed"; then
    echo "FAIL: squid package is installed"; audit_passed=false
else
    echo "PASS: squid package is not installed"
fi

if systemctl is-enabled squid.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: squid.service is enabled"; audit_passed=false
else
    echo "PASS: squid.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
