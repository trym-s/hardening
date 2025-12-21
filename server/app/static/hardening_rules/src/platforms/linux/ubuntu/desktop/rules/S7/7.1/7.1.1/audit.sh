#!/bin/bash

# 7.1.1 Ensure permissions on /etc/passwd are configured (Automated)

echo "Checking permissions on /etc/passwd..."

# Check if file exists
if [ ! -f /etc/passwd ]; then
    echo "FAIL: /etc/passwd does not exist"
    exit 1
fi

# Get current permissions
perm=$(stat -c "%a" /etc/passwd 2>/dev/null)
owner=$(stat -c "%U" /etc/passwd 2>/dev/null)
group=$(stat -c "%G" /etc/passwd 2>/dev/null)

echo "Current permissions: $perm"
echo "Owner: $owner"
echo "Group: $group"

# Check if permissions are 644 or more restrictive
if [ "$perm" = "644" ] || [ "$perm" = "600" ] || [ "$perm" = "400" ]; then
    if [ "$owner" = "root" ] && [ "$group" = "root" ]; then
        echo "PASS: /etc/passwd permissions are properly configured"
        exit 0
    else
        echo "FAIL: /etc/passwd owner or group is not root"
        exit 1
    fi
else
    echo "FAIL: /etc/passwd has incorrect permissions (expected 644 or more restrictive)"
    exit 1
fi
