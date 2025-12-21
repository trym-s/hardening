#!/bin/bash
# CIS Benchmark 2.2.2 - Ensure ldap client is not installed
audit_passed=true
echo "Checking ldap client..."

status=$(dpkg-query -W -f='${db:Status-Status}' ldap-utils 2>/dev/null)
if [ "$status" = "installed" ]; then
    echo "FAIL: ldap-utils client is installed"
    audit_passed=false
else
    echo "PASS: ldap-utils client is not installed"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
