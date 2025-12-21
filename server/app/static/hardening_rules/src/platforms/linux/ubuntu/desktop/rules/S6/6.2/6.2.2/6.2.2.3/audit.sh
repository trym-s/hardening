#!/bin/bash

# 6.2.2.3 Ensure system is disabled when audit logs are full (Automated)

echo "Checking system behavior when audit logs are full..."

# Check space_left_action
space_left_action=$(grep -E "^space_left_action\s*=" /etc/audit/auditd.conf 2>/dev/null | awk -F= '{print $2}' | tr -d ' ')
# Check admin_space_left_action
admin_space_left_action=$(grep -E "^admin_space_left_action\s*=" /etc/audit/auditd.conf 2>/dev/null | awk -F= '{print $2}' | tr -d ' ')
# Check disk_full_action
disk_full_action=$(grep -E "^disk_full_action\s*=" /etc/audit/auditd.conf 2>/dev/null | awk -F= '{print $2}' | tr -d ' ')
# Check disk_error_action
disk_error_action=$(grep -E "^disk_error_action\s*=" /etc/audit/auditd.conf 2>/dev/null | awk -F= '{print $2}' | tr -d ' ')

echo "space_left_action: ${space_left_action:-Not configured}"
echo "admin_space_left_action: ${admin_space_left_action:-Not configured}"
echo "disk_full_action: ${disk_full_action:-Not configured}"
echo "disk_error_action: ${disk_error_action:-Not configured}"

all_pass=true

if [[ ! "$space_left_action" =~ ^(email|exec|single|halt)$ ]]; then
    echo "FAIL: space_left_action should be email, exec, single, or halt"
    all_pass=false
fi

if [[ ! "$admin_space_left_action" =~ ^(single|halt)$ ]]; then
    echo "FAIL: admin_space_left_action should be single or halt"
    all_pass=false
fi

if [[ ! "$disk_full_action" =~ ^(single|halt)$ ]]; then
    echo "FAIL: disk_full_action should be single or halt"
    all_pass=false
fi

if [[ ! "$disk_error_action" =~ ^(single|halt)$ ]]; then
    echo "FAIL: disk_error_action should be single or halt"
    all_pass=false
fi

if $all_pass; then
    echo "PASS: System is configured appropriately when audit logs are full"
    exit 0
else
    exit 1
fi
