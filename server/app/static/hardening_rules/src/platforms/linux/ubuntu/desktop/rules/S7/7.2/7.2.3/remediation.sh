#!/bin/bash

# 7.2.3 Ensure all groups in /etc/passwd exist in /etc/group (Automated)

echo "Creating missing groups..."

# Create missing groups
for gid in $(awk -F: '{print $4}' /etc/passwd | sort -u); do
    if ! grep -q "^[^:]*:[^:]*:$gid:" /etc/group; then
        echo "Creating group with GID $gid"
        groupadd -g "$gid" "group$gid"
    fi
done

echo "All missing groups have been created"
