#!/bin/bash
# CIS Benchmark 2.1.19 - Ensure web server services are not in use
audit_passed=true
echo "Checking web server services..."

for pkg in apache2 nginx; do
    if dpkg-query -W -f='${db:Status-Status}' "$pkg" 2>/dev/null | grep -q "installed"; then
        echo "FAIL: $pkg package is installed"; audit_passed=false
    else
        echo "PASS: $pkg package is not installed"
    fi
done

for svc in apache2.service nginx.service; do
    if systemctl is-enabled "$svc" 2>/dev/null | grep -q "enabled"; then
        echo "FAIL: $svc is enabled"; audit_passed=false
    fi
done

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
