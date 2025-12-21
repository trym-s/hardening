#!/bin/bash

# CIS 5.4.2.8 - Ensure accounts without a valid login shell are locked
# Check that accounts with nologin shell are locked

echo "Checking accounts without valid login shell are locked..."

l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\/{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"

unlocked_accounts=""
while IFS= read -r l_user; do
    status=$(passwd -S "$l_user" | awk '{print $2}')
    if [ "$status" != "L" ]; then
        unlocked_accounts="$unlocked_accounts\nAccount: \"$l_user\" does not have a valid login shell and is not locked (status: $status)"
    fi
done < <(awk -v pat="$l_valid_shells" -F: '($1 != "root" && $(NF) !~ pat) {print $1}' /etc/passwd)

if [ -z "$unlocked_accounts" ]; then
    echo "PASS: All accounts without valid login shell are locked"
    exit 0
else
    echo "FAIL: The following accounts should be locked:"
    echo -e "$unlocked_accounts"
    exit 1
fi
