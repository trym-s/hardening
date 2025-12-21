#!/bin/bash
# CIS Benchmark 2.1.15 - Ensure snmp services are not in use
audit_passed=true
echo "Checking SNMP services..."

if dpkg-query -W -f='${db:Status-Status}' snmpd 2>/dev/null | grep -q "installed"; then
    echo "FAIL: snmpd package is installed"; audit_passed=false
else
    echo "PASS: snmpd package is not installed"
fi

if systemctl is-enabled snmpd.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: snmpd.service is enabled"; audit_passed=false
else
    echo "PASS: snmpd.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
