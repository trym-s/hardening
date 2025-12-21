#!/bin/bash

# 7.2.7 Ensure no duplicate user names exist (Automated)

echo "Checking for duplicate user names..."

# Find duplicate user names
duplicate_users=$(awk -F: '{print $1}' /etc/passwd | sort | uniq -d)

if [ -z "$duplicate_users" ]; then
    echo "PASS: No duplicate user names found"
    exit 0
else
    echo "FAIL: Found duplicate user names:"
    echo "$duplicate_users"
    exit 1
fi
