#!/bin/bash
# CIS Benchmark 2.1.5 - Ensure dnsmasq services are not in use
# Audit Script

audit_passed=true
echo "Checking dnsmasq services..."

if dpkg-query -W -f='${db:Status-Status}' dnsmasq 2>/dev/null | grep -q "installed"; then
    echo "FAIL: dnsmasq package is installed"
    audit_passed=false
else
    echo "PASS: dnsmasq package is not installed"
fi

if systemctl is-enabled dnsmasq.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: dnsmasq.service is enabled"
    audit_passed=false
else
    echo "PASS: dnsmasq.service is not enabled"
fi

echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - dnsmasq services are not in use"
    exit 0
else
    echo "AUDIT RESULT: FAIL - dnsmasq services are in use"
    exit 1
fi
