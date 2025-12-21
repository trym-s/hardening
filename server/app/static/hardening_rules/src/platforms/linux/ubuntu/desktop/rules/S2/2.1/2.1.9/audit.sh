#!/bin/bash
# CIS Benchmark 2.1.9 - Ensure network file system services are not in use
audit_passed=true
echo "Checking NFS server services..."

if dpkg-query -W -f='${db:Status-Status}' nfs-kernel-server 2>/dev/null | grep -q "installed"; then
    echo "FAIL: nfs-kernel-server package is installed"; audit_passed=false
else
    echo "PASS: nfs-kernel-server package is not installed"
fi

if systemctl is-enabled nfs-server.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: nfs-server.service is enabled"; audit_passed=false
else
    echo "PASS: nfs-server.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
