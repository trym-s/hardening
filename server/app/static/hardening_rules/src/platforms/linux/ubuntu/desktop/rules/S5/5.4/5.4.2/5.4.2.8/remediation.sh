#!/bin/bash

# CIS 5.4.2.8 - Ensure accounts without a valid login shell are locked
# Lock accounts that don't have a valid login shell

echo "Locking accounts without valid login shell..."

l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\/{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"

while IFS= read -r l_user; do
    status=$(passwd -S "$l_user" | awk '{print $2}')
    if [ "$status" != "L" ]; then
        echo "Locking account: $l_user"
        usermod -L "$l_user"
    fi
done < <(awk -v pat="$l_valid_shells" -F: '($1 != "root" && $(NF) !~ pat) {print $1}' /etc/passwd)

echo "SUCCESS: Accounts without valid login shell are now locked"
