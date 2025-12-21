#!/bin/bash
# CIS Benchmark 2.1.8 - Ensure message access agent services are not in use
audit_passed=true
echo "Checking message access agent services..."

for pkg in dovecot-imapd dovecot-pop3d; do
    if dpkg-query -W -f='${db:Status-Status}' "$pkg" 2>/dev/null | grep -q "installed"; then
        echo "FAIL: $pkg package is installed"; audit_passed=false
    else
        echo "PASS: $pkg package is not installed"
    fi
done

if systemctl is-enabled dovecot.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: dovecot.service is enabled"; audit_passed=false
else
    echo "PASS: dovecot.service is not enabled"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
