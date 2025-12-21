#!/bin/bash

# 6.2.3.1 Ensure changes to system administration scope (sudoers) is collected (Automated)

echo "Checking if changes to sudoers are collected..."

# Check for audit rules
rules_found=$(auditctl -l 2>/dev/null | grep -E "/etc/sudoers|/etc/sudoers.d/")

if [ -n "$rules_found" ]; then
    echo "PASS: Changes to sudoers are being audited"
    echo "$rules_found"
    exit 0
else
    echo "FAIL: Changes to sudoers are not being audited"
    exit 1
fi
