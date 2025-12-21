#!/bin/bash

# CIS 5.4.2.7 - Ensure system accounts do not have a valid login shell
# Check that system accounts have nologin shell

echo "Checking system accounts for valid login shells..."

UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\/{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"

invalid_accounts=$(awk -v pat="$l_valid_shells" -F: '($1!~/^(root|halt|sync|shutdown|nfsnobody)$/ && ($3<'"$UID_MIN"' || $3 == 65534) && $(NF) ~ pat) {print "Service account: \"" $1 "\" has a valid shell: " $7}' /etc/passwd)

if [ -z "$invalid_accounts" ]; then
    echo "PASS: All system accounts have nologin shell"
    exit 0
else
    echo "FAIL: The following system accounts have valid login shells:"
    echo "$invalid_accounts"
    exit 1
fi
