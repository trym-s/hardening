#!/bin/bash

# 6.2.3.3 Ensure events that modify the sudo log file are collected (Automated)

echo "Checking if sudo log file modifications are collected..."

# First find the sudo log file location
sudo_log=$(grep -r "logfile" /etc/sudoers* 2>/dev/null | grep -v "^#" | awk -F= '{print $2}' | tr -d ' "' | head -1)

if [ -z "$sudo_log" ]; then
    sudo_log="/var/log/sudo.log"
fi

echo "Sudo log file: $sudo_log"

# Check for audit rules
rules_found=$(auditctl -l 2>/dev/null | grep "$sudo_log")

if [ -n "$rules_found" ]; then
    echo "PASS: Sudo log file modifications are being audited"
    echo "$rules_found"
    exit 0
else
    echo "FAIL: Sudo log file modifications are not being audited"
    exit 1
fi
