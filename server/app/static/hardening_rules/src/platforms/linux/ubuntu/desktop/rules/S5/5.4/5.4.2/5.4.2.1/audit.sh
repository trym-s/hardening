#!/bin/bash

# CIS 5.4.2.1 - Ensure root is the only UID 0 account
# Verify only root has UID 0

echo "Checking for accounts with UID 0..."

uid0_accounts=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)
uid0_count=$(echo "$uid0_accounts" | wc -l)

if [ "$uid0_accounts" = "root" ] && [ "$uid0_count" -eq 1 ]; then
    echo "PASS: Only root has UID 0"
    exit 0
else
    echo "FAIL: The following accounts have UID 0:"
    echo "$uid0_accounts"
    exit 1
fi
