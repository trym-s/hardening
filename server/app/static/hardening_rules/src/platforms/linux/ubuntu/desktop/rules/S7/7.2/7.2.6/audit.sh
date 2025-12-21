#!/bin/bash

# 7.2.6 Ensure no duplicate GIDs exist (Automated)

echo "Checking for duplicate GIDs..."

# Find duplicate GIDs
duplicate_gids=$(awk -F: '{print $3}' /etc/group | sort | uniq -d)

if [ -z "$duplicate_gids" ]; then
    echo "PASS: No duplicate GIDs found"
    exit 0
else
    echo "FAIL: Found duplicate GIDs:"
    for gid in $duplicate_gids; do
        echo "GID $gid used by:"
        awk -F: -v gid="$gid" '($3 == gid) {print "  "$1}' /etc/group
    done
    exit 1
fi
