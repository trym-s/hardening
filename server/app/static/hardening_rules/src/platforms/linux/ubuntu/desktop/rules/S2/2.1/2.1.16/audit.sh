#!/bin/bash
# CIS Benchmark 2.1.16 - Ensure telnet server services are not in use
audit_passed=true
echo "Checking telnet server services..."

if dpkg-query -W -f='${db:Status-Status}' telnetd 2>/dev/null | grep -q "installed"; then
    echo "FAIL: telnetd package is installed"; audit_passed=false
else
    echo "PASS: telnetd package is not installed"
fi

if systemctl is-enabled telnet.socket 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: telnet.socket is enabled"; audit_passed=false
else
    echo "PASS: telnet.socket is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
