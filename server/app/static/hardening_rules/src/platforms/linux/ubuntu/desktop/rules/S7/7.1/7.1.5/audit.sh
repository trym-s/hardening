#!/bin/bash

# 7.1.5 Ensure permissions on /etc/shadow are configured (Automated)

echo "Checking permissions on /etc/shadow..."

# Check if file exists
if [ ! -f /etc/shadow ]; then
    echo "FAIL: /etc/shadow does not exist"
    exit 1
fi

# Get current permissions
perm=$(stat -c "%a" /etc/shadow 2>/dev/null)
owner=$(stat -c "%U" /etc/shadow 2>/dev/null)
group=$(stat -c "%G" /etc/shadow 2>/dev/null)

echo "Current permissions: $perm"
echo "Owner: $owner"
echo "Group: $group"

# Check if permissions are 000 or 0400 or 0640
if [ "$perm" = "000" ] || [ "$perm" = "400" ] || [ "$perm" = "640" ]; then
    if [ "$owner" = "root" ]; then
        if [ "$group" = "root" ] || [ "$group" = "shadow" ]; then
            echo "PASS: /etc/shadow permissions are properly configured"
            exit 0
        else
            echo "FAIL: /etc/shadow group is not root or shadow"
            exit 1
        fi
    else
        echo "FAIL: /etc/shadow owner is not root"
        exit 1
    fi
else
    echo "FAIL: /etc/shadow has incorrect permissions (expected 000, 400, or 640)"
    exit 1
fi
