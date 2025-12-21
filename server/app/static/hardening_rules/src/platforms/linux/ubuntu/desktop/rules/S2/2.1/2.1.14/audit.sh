#!/bin/bash
# CIS Benchmark 2.1.14 - Ensure samba file server services are not in use
audit_passed=true
echo "Checking samba services..."

if dpkg-query -W -f='${db:Status-Status}' samba 2>/dev/null | grep -q "installed"; then
    echo "FAIL: samba package is installed"; audit_passed=false
else
    echo "PASS: samba package is not installed"
fi

if systemctl is-enabled smbd.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: smbd.service is enabled"; audit_passed=false
else
    echo "PASS: smbd.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
