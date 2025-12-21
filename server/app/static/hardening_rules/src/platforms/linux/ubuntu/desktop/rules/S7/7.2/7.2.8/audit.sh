#!/bin/bash

# 7.2.8 Ensure no duplicate group names exist (Automated)

echo "Checking for duplicate group names..."

# Find duplicate group names
duplicate_groups=$(awk -F: '{print $1}' /etc/group | sort | uniq -d)

if [ -z "$duplicate_groups" ]; then
    echo "PASS: No duplicate group names found"
    exit 0
else
    echo "FAIL: Found duplicate group names:"
    echo "$duplicate_groups"
    exit 1
fi
