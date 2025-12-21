#!/bin/bash
# CIS Benchmark 2.1.4 - Ensure dns server services are not in use
# Audit Script

audit_passed=true
echo "Checking DNS server services..."

if dpkg-query -W -f='${db:Status-Status}' bind9 2>/dev/null | grep -q "installed"; then
    echo "FAIL: bind9 package is installed"
    audit_passed=false
else
    echo "PASS: bind9 package is not installed"
fi

if systemctl is-enabled named.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: named.service is enabled"
    audit_passed=false
else
    echo "PASS: named.service is not enabled"
fi

echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - DNS server services are not in use"
    exit 0
else
    echo "AUDIT RESULT: FAIL - DNS server services are in use"
    exit 1
fi
