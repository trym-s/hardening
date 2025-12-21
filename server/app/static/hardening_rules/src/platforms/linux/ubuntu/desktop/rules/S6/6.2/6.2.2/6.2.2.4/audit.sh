#!/bin/bash

# 6.2.2.4 Ensure system warns when audit logs are low on space (Automated)

echo "Checking if system warns when audit logs are low on space..."

# Check space_left setting
space_left=$(grep -E "^space_left\s*=" /etc/audit/auditd.conf 2>/dev/null | awk -F= '{print $2}' | tr -d ' ')
# Check admin_space_left setting
admin_space_left=$(grep -E "^admin_space_left\s*=" /etc/audit/auditd.conf 2>/dev/null | awk -F= '{print $2}' | tr -d ' ')

echo "space_left: ${space_left:-Not configured} MB"
echo "admin_space_left: ${admin_space_left:-Not configured} MB"

all_pass=true

if [ -z "$space_left" ] || [ "$space_left" -le 0 ]; then
    echo "FAIL: space_left is not configured or set to 0"
    all_pass=false
fi

if [ -z "$admin_space_left" ] || [ "$admin_space_left" -le 0 ]; then
    echo "FAIL: admin_space_left is not configured or set to 0"
    all_pass=false
fi

if [ -n "$space_left" ] && [ -n "$admin_space_left" ] && [ "$admin_space_left" -ge "$space_left" ]; then
    echo "FAIL: admin_space_left should be less than space_left"
    all_pass=false
fi

if $all_pass; then
    echo "PASS: System is configured to warn when audit logs are low on space"
    exit 0
else
    exit 1
fi
