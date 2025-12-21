#!/bin/bash

# 6.2.1.3 Ensure auditing for processes that start prior to auditd is enabled (Automated)

echo "Checking if auditing for processes that start prior to auditd is enabled..."

# Check if audit=1 is set in kernel parameters
grub_audit=$(grep -E "^\s*linux" /boot/grub/grub.cfg 2>/dev/null | grep -v "audit=1")

if [ -z "$grub_audit" ]; then
    echo "PASS: audit=1 is set in all kernel boot parameters"
    exit 0
else
    echo "FAIL: audit=1 is not set in all kernel boot parameters"
    echo "Lines without audit=1:"
    echo "$grub_audit"
    exit 1
fi
