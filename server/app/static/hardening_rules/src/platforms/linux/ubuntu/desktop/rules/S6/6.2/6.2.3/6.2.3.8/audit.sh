#!/bin/bash

# 6.2.3.8 Ensure events that modify user/group information are collected (Automated)

echo "Checking if user/group information modifications are collected..."

files="/etc/group /etc/passwd /etc/gshadow /etc/shadow /etc/security/opasswd"
all_monitored=true

for file in $files; do
    if ! auditctl -l 2>/dev/null | grep -q "$file"; then
        echo "FAIL: $file is not being monitored"
        all_monitored=false
    fi
done

if $all_monitored; then
    echo "PASS: All user/group files are being monitored"
    exit 0
else
    exit 1
fi
