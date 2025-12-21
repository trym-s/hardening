#!/bin/bash
# CIS Benchmark 2.2.1 - Ensure ftp client is not installed
audit_passed=true
echo "Checking ftp client..."

status=$(dpkg-query -W -f='${db:Status-Status}' ftp 2>/dev/null)
if [ "$status" = "installed" ]; then
    echo "FAIL: ftp client is installed"
    audit_passed=false
else
    echo "PASS: ftp client is not installed"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
