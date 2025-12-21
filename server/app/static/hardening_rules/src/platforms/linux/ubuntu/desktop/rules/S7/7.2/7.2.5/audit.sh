#!/bin/bash

# 7.2.5 Ensure no duplicate UIDs exist (Automated)

echo "Checking for duplicate UIDs..."

# Find duplicate UIDs
duplicate_uids=$(awk -F: '{print $3}' /etc/passwd | sort | uniq -d)

if [ -z "$duplicate_uids" ]; then
    echo "PASS: No duplicate UIDs found"
    exit 0
else
    echo "FAIL: Found duplicate UIDs:"
    for uid in $duplicate_uids; do
        echo "UID $uid used by:"
        awk -F: -v uid="$uid" '($3 == uid) {print "  "$1}' /etc/passwd
    done
    exit 1
fi
