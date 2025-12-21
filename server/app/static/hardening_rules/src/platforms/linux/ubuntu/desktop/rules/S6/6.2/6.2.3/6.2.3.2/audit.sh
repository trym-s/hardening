#!/bin/bash

# 6.2.3.2 Ensure actions as another user are always logged (Automated)

echo "Checking if actions as another user are logged..."

# Check for execve audit rules
rules_found=$(auditctl -l 2>/dev/null | grep -E "execve.*always,exit")

if [ -n "$rules_found" ]; then
    echo "PASS: Actions as another user are being audited"
    echo "$rules_found"
    exit 0
else
    echo "FAIL: Actions as another user are not being audited"
    exit 1
fi
