#!/bin/bash

# 7.2.3 Ensure all groups in /etc/passwd exist in /etc/group (Automated)

echo "Checking if all groups in /etc/passwd exist in /etc/group..."

# Check for groups in /etc/passwd that don't exist in /etc/group
missing_groups=""
for gid in $(awk -F: '{print $4}' /etc/passwd | sort -u); do
    if ! grep -q "^[^:]*:[^:]*:$gid:" /etc/group; then
        missing_groups="$missing_groups\nGID $gid"
    fi
done

if [ -z "$missing_groups" ]; then
    echo "PASS: All groups in /etc/passwd exist in /etc/group"
    exit 0
else
    echo "FAIL: Found groups in /etc/passwd that don't exist in /etc/group:"
    echo -e "$missing_groups"
    exit 1
fi
