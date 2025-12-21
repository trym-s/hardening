#!/bin/bash

# 7.2.4 Ensure shadow group is empty (Automated)

echo "Checking if shadow group is empty..."

# Get shadow group members
shadow_members=$(grep "^shadow:" /etc/group | cut -d: -f4)

# Check if any users have shadow as primary group
shadow_primary=$(awk -F: '($4 == "42") {print $1}' /etc/passwd)

if [ -z "$shadow_members" ] && [ -z "$shadow_primary" ]; then
    echo "PASS: Shadow group is empty"
    exit 0
else
    echo "FAIL: Shadow group is not empty:"
    if [ -n "$shadow_members" ]; then
        echo "Shadow group members: $shadow_members"
    fi
    if [ -n "$shadow_primary" ]; then
        echo "Users with shadow as primary group: $shadow_primary"
    fi
    exit 1
fi
