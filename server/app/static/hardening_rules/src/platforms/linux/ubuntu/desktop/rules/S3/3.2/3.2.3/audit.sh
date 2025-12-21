#!/bin/bash
# CIS 3.2.3 Ensure rds kernel module is not available

MODULE="rds"

echo "Checking $MODULE kernel module status..."

FAIL=0

# Check if module is disabled (install redirects to /bin/true or /bin/false)
if modprobe -n -v "$MODULE" 2>&1 | grep -qE "install /bin/(true|false)"; then
    echo "PASS: $MODULE module is disabled"
else
    echo "FAIL: $MODULE module is not disabled"
    FAIL=1
fi

# Check if module is blacklisted
if grep -rqs "^\s*blacklist\s\+$MODULE\b" /etc/modprobe.d/; then
    echo "PASS: $MODULE module is blacklisted"
else
    echo "WARNING: $MODULE module is not blacklisted"
fi

# Check if module is currently loaded
if lsmod | grep -q "^$MODULE"; then
    echo "FAIL: $MODULE module is currently loaded"
    FAIL=1
else
    echo "PASS: $MODULE module is not loaded"
fi

if [ "$FAIL" -eq 0 ]; then
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
