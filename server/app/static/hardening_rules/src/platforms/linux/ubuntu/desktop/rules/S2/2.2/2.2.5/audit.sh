#!/bin/bash
# CIS Benchmark 2.2.5 - Ensure talk client is not installed
audit_passed=true
echo "Checking talk client..."

status=$(dpkg-query -W -f='${db:Status-Status}' talk 2>/dev/null)
if [ "$status" = "installed" ]; then
    echo "FAIL: talk client is installed"
    audit_passed=false
else
    echo "PASS: talk client is not installed"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
