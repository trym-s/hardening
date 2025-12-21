#!/bin/bash

# 7.1.10 Ensure permissions on /etc/security/opasswd are configured (Automated)

echo "Checking permissions on /etc/security/opasswd..."

# Check if file exists
if [ ! -f /etc/security/opasswd ]; then
    echo "INFO: /etc/security/opasswd does not exist (may not be created yet)"
    exit 0
fi

# Get current permissions
perm=$(stat -c "%a" /etc/security/opasswd 2>/dev/null)
owner=$(stat -c "%U" /etc/security/opasswd 2>/dev/null)
group=$(stat -c "%G" /etc/security/opasswd 2>/dev/null)

echo "Current permissions: $perm"
echo "Owner: $owner"
echo "Group: $group"

# Check if permissions are 600 or more restrictive
if [ "$perm" = "600" ] || [ "$perm" = "400" ] || [ "$perm" = "000" ]; then
    if [ "$owner" = "root" ] && [ "$group" = "root" ]; then
        echo "PASS: /etc/security/opasswd permissions are properly configured"
        exit 0
    else
        echo "FAIL: /etc/security/opasswd owner or group is not root"
        exit 1
    fi
else
    echo "FAIL: /etc/security/opasswd has incorrect permissions (expected 600 or more restrictive)"
    exit 1
fi
