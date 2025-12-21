#!/bin/bash

# 7.1.12 Ensure no files or directories without an owner and a group exist (Automated)

echo "Checking for files and directories without an owner and a group..."

# Find files without owner
no_owner=$(find / -xdev -nouser ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" ! -path "/run/*" 2>/dev/null)

# Find files without group
no_group=$(find / -xdev -nogroup ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" ! -path "/run/*" 2>/dev/null)

if [ -z "$no_owner" ] && [ -z "$no_group" ]; then
    echo "PASS: No files or directories without an owner or group found"
    exit 0
else
    echo "FAIL: Found files or directories without an owner or group:"
    if [ -n "$no_owner" ]; then
        echo "Files without owner:"
        echo "$no_owner"
    fi
    if [ -n "$no_group" ]; then
        echo "Files without group:"
        echo "$no_group"
    fi
    exit 1
fi
