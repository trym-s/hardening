#!/bin/bash
# CIS Benchmark 2.1.12 - Ensure rpcbind services are not in use
audit_passed=true
echo "Checking rpcbind services..."

if dpkg-query -W -f='${db:Status-Status}' rpcbind 2>/dev/null | grep -q "installed"; then
    echo "FAIL: rpcbind package is installed"; audit_passed=false
else
    echo "PASS: rpcbind package is not installed"
fi

for svc in rpcbind.service rpcbind.socket; do
    if systemctl is-enabled "$svc" 2>/dev/null | grep -q "enabled"; then
        echo "FAIL: $svc is enabled"; audit_passed=false
    fi
done

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
