#!/bin/bash
# CIS Benchmark 2.2.3 - Ensure nis client is not installed
audit_passed=true
echo "Checking nis client..."

status=$(dpkg-query -W -f='${db:Status-Status}' nis 2>/dev/null)
if [ "$status" = "installed" ]; then
    echo "FAIL: nis client is installed"
    audit_passed=false
else
    echo "PASS: nis client is not installed"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
