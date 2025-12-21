#!/bin/bash

# 7.1.9 Ensure permissions on /etc/shells are configured (Automated)

echo "Checking permissions on /etc/shells..."

# Check if file exists
if [ ! -f /etc/shells ]; then
    echo "FAIL: /etc/shells does not exist"
    exit 1
fi

# Get current permissions
perm=$(stat -c "%a" /etc/shells 2>/dev/null)
owner=$(stat -c "%U" /etc/shells 2>/dev/null)
group=$(stat -c "%G" /etc/shells 2>/dev/null)

echo "Current permissions: $perm"
echo "Owner: $owner"
echo "Group: $group"

# Check if permissions are 644 or more restrictive
if [ "$perm" = "644" ] || [ "$perm" = "600" ] || [ "$perm" = "400" ]; then
    if [ "$owner" = "root" ] && [ "$group" = "root" ]; then
        echo "PASS: /etc/shells permissions are properly configured"
        exit 0
    else
        echo "FAIL: /etc/shells owner or group is not root"
        exit 1
    fi
else
    echo "FAIL: /etc/shells has incorrect permissions (expected 644 or more restrictive)"
    exit 1
fi
