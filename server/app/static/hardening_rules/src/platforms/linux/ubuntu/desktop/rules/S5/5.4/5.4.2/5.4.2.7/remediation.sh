#!/bin/bash

# CIS 5.4.2.7 - Ensure system accounts do not have a valid login shell
# Set nologin shell for system accounts

echo "Setting nologin shell for system accounts..."

UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
NOLOGIN=$(command -v nologin)

l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\/{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"

count=0
awk -v pat="$l_valid_shells" -F: '($1!~/^(root|halt|sync|shutdown|nfsnobody)$/ && ($3<'"$UID_MIN"' || $3 == 65534) && $(NF) ~ pat) {print $1}' /etc/passwd | while read -r user; do
    echo "Setting nologin for: $user"
    usermod -s "$NOLOGIN" "$user"
    count=$((count + 1))
done

echo "SUCCESS: System accounts configured with nologin shell"
