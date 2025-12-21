#!/bin/bash

# CIS 5.4.2.3 - Ensure group root is the only GID 0 group
# Verify only root group has GID 0

echo "Checking for groups with GID 0..."

gid0_groups=$(awk -F: '$3=="0"{print $1":"$3}' /etc/group)

if [ "$gid0_groups" = "root:0" ]; then
    echo "PASS: Only root group has GID 0"
    exit 0
else
    echo "Groups with GID 0:"
    echo "$gid0_groups"
    
    # Check if only root
    non_root=$(echo "$gid0_groups" | grep -v "^root:")
    if [ -z "$non_root" ]; then
        echo "PASS: Only root group has GID 0"
        exit 0
    else
        echo "FAIL: Non-root groups have GID 0"
        exit 1
    fi
fi
