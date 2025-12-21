#!/bin/bash
# CIS Benchmark 2.2.7 - Ensure tftp client is not installed
audit_passed=true
echo "Checking tftp client..."

status=$(dpkg-query -W -f='${db:Status-Status}' tftp 2>/dev/null)
if [ "$status" = "installed" ]; then
    echo "FAIL: tftp client is installed"
    audit_passed=false
else
    echo "PASS: tftp client is not installed"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
