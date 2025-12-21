#!/bin/bash

# 6.2.2.2 Ensure audit logs are not automatically deleted (Automated)

echo "Checking if audit logs are not automatically deleted..."

# Check max_log_file_action setting
max_log_file_action=$(grep -E "^max_log_file_action\s*=" /etc/audit/auditd.conf 2>/dev/null | awk -F= '{print $2}' | tr -d ' ')

echo "max_log_file_action: ${max_log_file_action:-Not configured}"

if [ "$max_log_file_action" = "keep_logs" ]; then
    echo "PASS: max_log_file_action is set to keep_logs"
    exit 0
else
    echo "FAIL: max_log_file_action is not set to keep_logs (current: $max_log_file_action)"
    exit 1
fi
