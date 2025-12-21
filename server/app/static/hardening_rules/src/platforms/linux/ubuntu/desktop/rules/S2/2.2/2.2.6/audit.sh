#!/bin/bash
# CIS Benchmark 2.2.6 - Ensure telnet client is not installed
audit_passed=true
echo "Checking telnet client..."

# Check for both possible package names
for pkg in telnet inetutils-telnet; do
    status=$(dpkg-query -W -f='${db:Status-Status}' "$pkg" 2>/dev/null)
    if [ "$status" = "installed" ]; then
        echo "FAIL: $pkg is installed"
        audit_passed=false
    fi
done

if [ "$audit_passed" = true ]; then
    echo "PASS: telnet client is not installed"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
