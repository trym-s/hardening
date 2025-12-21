#!/bin/bash

# 6.2.3.6 Ensure use of privileged commands are collected (Automated)

echo "Checking if privileged command usage is collected..."

privileged_count=$(auditctl -l 2>/dev/null | grep -c "perm=x.*privileged")

if [ "$privileged_count" -gt 10 ]; then
    echo "PASS: $privileged_count privileged commands are being audited"
    exit 0
else
    echo "FAIL: Only $privileged_count privileged commands found (should be many more)"
    exit 1
fi
