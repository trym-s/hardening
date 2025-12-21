#!/bin/bash
# CIS Benchmark 2.1.3 - Ensure dhcp server services are not in use
# Audit Script

audit_passed=true
echo "Checking DHCP server services..."

if dpkg-query -W -f='${db:Status-Status}' isc-dhcp-server 2>/dev/null | grep -q "installed"; then
    echo "FAIL: isc-dhcp-server package is installed"
    audit_passed=false
else
    echo "PASS: isc-dhcp-server package is not installed"
fi

for svc in isc-dhcp-server.service isc-dhcp-server6.service; do
    if systemctl is-enabled "$svc" 2>/dev/null | grep -q "enabled"; then
        echo "FAIL: $svc is enabled"
        audit_passed=false
    fi
done

echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - DHCP server services are not in use"
    exit 0
else
    echo "AUDIT RESULT: FAIL - DHCP server services are in use"
    exit 1
fi
