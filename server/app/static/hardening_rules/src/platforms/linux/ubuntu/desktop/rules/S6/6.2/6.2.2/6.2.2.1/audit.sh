#!/bin/bash

# 6.2.2.1 Ensure audit log storage size is configured (Automated)

echo "Checking audit log storage size configuration..."

# Check max_log_file setting
max_log_file=$(grep -E "^max_log_file\s*=" /etc/audit/auditd.conf 2>/dev/null | awk -F= '{print $2}' | tr -d ' ')

echo "max_log_file: ${max_log_file:-Not configured}"

if [ -n "$max_log_file" ] && [ "$max_log_file" -gt 0 ]; then
    echo "PASS: max_log_file is configured to $max_log_file MB"
    exit 0
else
    echo "FAIL: max_log_file is not configured or set to 0"
    exit 1
fi
