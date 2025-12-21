#!/bin/bash
# CIS Benchmark 2.1.21 - Ensure X window server services are not in use
audit_passed=true
echo "Checking X Window server services..."

xorg_installed=$(dpkg-query -W -f='${binary:Package}\n' 'xserver-xorg*' 2>/dev/null | head -1)
if [ -n "$xorg_installed" ]; then
    echo "FAIL: X Window server packages are installed"
    dpkg-query -W -f='${binary:Package}\t${Status}\n' 'xserver-xorg*' 2>/dev/null
    audit_passed=false
else
    echo "PASS: X Window server packages are not installed"
fi

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
