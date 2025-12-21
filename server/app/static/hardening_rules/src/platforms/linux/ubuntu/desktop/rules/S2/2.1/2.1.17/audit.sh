#!/bin/bash
# CIS Benchmark 2.1.17 - Ensure tftp server services are not in use
audit_passed=true
echo "Checking TFTP server services..."

if dpkg-query -W -f='${db:Status-Status}' tftpd-hpa 2>/dev/null | grep -q "installed"; then
    echo "FAIL: tftpd-hpa package is installed"; audit_passed=false
else
    echo "PASS: tftpd-hpa package is not installed"
fi

if systemctl is-enabled tftpd-hpa.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: tftpd-hpa.service is enabled"; audit_passed=false
else
    echo "PASS: tftpd-hpa.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
