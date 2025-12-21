#!/bin/bash

# 6.2.3.7 Ensure unsuccessful file access attempts are collected (Automated)

echo "Checking if unsuccessful file access attempts are collected..."

rules_found=$(auditctl -l 2>/dev/null | grep -E "EACCES|EPERM")

if echo "$rules_found" | grep -q "EACCES" && echo "$rules_found" | grep -q "EPERM"; then
    echo "PASS: Unsuccessful file access attempts are being audited"
    exit 0
else
    echo "FAIL: Unsuccessful file access attempts are not fully audited"
    exit 1
fi
