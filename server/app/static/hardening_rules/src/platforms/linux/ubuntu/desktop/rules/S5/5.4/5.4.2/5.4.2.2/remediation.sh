#!/bin/bash

# CIS 5.4.2.2 - Ensure root is the only GID 0 account
# Ensure root has GID 0 and remove other users from GID 0

echo "Ensuring root user has GID 0..."

# Ensure root has GID 0
usermod -g 0 root 2>/dev/null

echo "Checking for non-root accounts with primary GID 0..."

non_root_gid0=$(awk -F: '($1 !~ /^(root|sync|shutdown|halt|operator)/ && $4=="0") {print $1}' /etc/passwd)

if [ -z "$non_root_gid0" ]; then
    echo "SUCCESS: Only root has primary GID 0"
    return 0
fi

echo "WARNING: The following non-root accounts have primary GID 0:"
echo "$non_root_gid0"
echo ""
echo "Manual action required:"
echo "For each account listed above, run:"
echo "  usermod -g <new_gid> <username>"
echo ""
return 1
