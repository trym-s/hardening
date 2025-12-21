#!/bin/bash

# 7.1.4 Ensure permissions on /etc/group- are configured (Automated)

echo "Checking permissions on /etc/group-..."

# Check if file exists
if [ ! -f /etc/group- ]; then
    echo "FAIL: /etc/group- does not exist"
    exit 1
fi

# Get current permissions
perm=$(stat -c "%a" /etc/group- 2>/dev/null)
owner=$(stat -c "%U" /etc/group- 2>/dev/null)
group=$(stat -c "%G" /etc/group- 2>/dev/null)

echo "Current permissions: $perm"
echo "Owner: $owner"
echo "Group: $group"

# Check if permissions are 644 or more restrictive
if [ "$perm" = "644" ] || [ "$perm" = "600" ] || [ "$perm" = "400" ]; then
    if [ "$owner" = "root" ] && [ "$group" = "root" ]; then
        echo "PASS: /etc/group- permissions are properly configured"
        exit 0
    else
        echo "FAIL: /etc/group- owner or group is not root"
        exit 1
    fi
else
    echo "FAIL: /etc/group- has incorrect permissions (expected 644 or more restrictive)"
    exit 1
fi
