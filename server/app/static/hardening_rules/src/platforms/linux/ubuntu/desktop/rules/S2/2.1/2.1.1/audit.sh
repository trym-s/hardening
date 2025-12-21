#!/bin/bash
# CIS Benchmark 2.1.1 - Ensure autofs services are not in use
# Audit Script

audit_passed=true

echo "Checking autofs services..."

# Check if autofs is installed
if dpkg-query -W -f='${db:Status-Status}' autofs 2>/dev/null | grep -q "installed"; then
    echo "FAIL: autofs package is installed"
    audit_passed=false
else
    echo "PASS: autofs package is not installed"
fi

# Check if autofs.service is enabled
if systemctl is-enabled autofs.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: autofs.service is enabled"
    audit_passed=false
else
    echo "PASS: autofs.service is not enabled"
fi

# Check if autofs.service is active
if systemctl is-active autofs.service 2>/dev/null | grep -q "^active"; then
    echo "FAIL: autofs.service is active"
    audit_passed=false
else
    echo "PASS: autofs.service is not active"
fi

echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - autofs services are not in use"
    exit 0
else
    echo "AUDIT RESULT: FAIL - autofs services are in use"
    exit 1
fi
