#!/bin/bash

# CIS 5.4.2.1 - Ensure root is the only UID 0 account
# Manual remediation - change UID for non-root accounts with UID 0

echo "Checking for non-root accounts with UID 0..."

non_root_uid0=$(awk -F: '($3 == 0 && $1 != "root") { print $1 }' /etc/passwd)

if [ -z "$non_root_uid0" ]; then
    echo "No non-root accounts with UID 0 found"
    echo "SUCCESS: Only root has UID 0"
    return 0
fi

echo "WARNING: The following non-root accounts have UID 0:"
echo "$non_root_uid0"
echo ""
echo "Manual action required:"
echo "For each account listed above, run:"
echo "  usermod -u <new_uid> <username>"
echo ""
echo "Example: usermod -u 1001 baduser"
return 1
