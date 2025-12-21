#!/bin/bash
# CIS Benchmark 2.1.7 - Ensure ldap server services are not in use
audit_passed=true
echo "Checking LDAP server services..."

if dpkg-query -W -f='${db:Status-Status}' slapd 2>/dev/null | grep -q "installed"; then
    echo "FAIL: slapd package is installed"; audit_passed=false
else
    echo "PASS: slapd package is not installed"
fi

if systemctl is-enabled slapd.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: slapd.service is enabled"; audit_passed=false
else
    echo "PASS: slapd.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
