#!/bin/bash

# 6.2.1.4 Ensure audit_backlog_limit is sufficient (Automated)

echo "Checking if audit_backlog_limit is sufficient..."

# Check current audit_backlog_limit
backlog_limit=$(grep -oP 'audit_backlog_limit=\K\d+' /boot/grub/grub.cfg 2>/dev/null | head -1)

if [ -n "$backlog_limit" ]; then
    if [ "$backlog_limit" -ge 8192 ]; then
        echo "PASS: audit_backlog_limit is set to $backlog_limit (>= 8192)"
        exit 0
    else
        echo "FAIL: audit_backlog_limit is set to $backlog_limit (should be >= 8192)"
        exit 1
    fi
else
    echo "FAIL: audit_backlog_limit is not set"
    exit 1
fi
