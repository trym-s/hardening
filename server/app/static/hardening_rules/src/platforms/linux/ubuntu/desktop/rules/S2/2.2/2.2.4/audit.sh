#!/bin/bash
# CIS Benchmark 2.2.4 - Ensure rsh client is not installed
audit_passed=true
echo "Checking rsh client..."

status=$(dpkg-query -W -f='${db:Status-Status}' rsh-client 2>/dev/null)
if [ "$status" = "installed" ]; then
    echo "FAIL: rsh-client is installed"
    audit_passed=false
else
    echo "PASS: rsh-client is not installed"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
