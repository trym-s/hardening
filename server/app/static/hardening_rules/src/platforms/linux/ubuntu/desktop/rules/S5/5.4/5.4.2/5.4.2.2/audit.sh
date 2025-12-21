#!/bin/bash

# CIS 5.4.2.2 - Ensure root is the only GID 0 account
# Verify only root has GID 0 as primary group

echo "Checking for accounts with primary GID 0..."

# Excluded system accounts: sync, shutdown, halt, operator
gid0_accounts=$(awk -F: '($1 !~ /^(sync|shutdown|halt|operator)/ && $4=="0") {print $1":"$4}' /etc/passwd)

if [ "$gid0_accounts" = "root:0" ]; then
    echo "PASS: Only root has primary GID 0"
    exit 0
else
    echo "Accounts with primary GID 0:"
    echo "$gid0_accounts"
    
    # Check if only root
    non_root=$(echo "$gid0_accounts" | grep -v "^root:")
    if [ -z "$non_root" ]; then
        echo "PASS: Only root has primary GID 0"
        exit 0
    else
        echo "FAIL: Non-root accounts have GID 0 as primary group"
        exit 1
    fi
fi
