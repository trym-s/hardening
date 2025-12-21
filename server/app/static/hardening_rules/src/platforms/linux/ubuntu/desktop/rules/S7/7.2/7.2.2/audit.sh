#!/bin/bash

# 7.2.2 Ensure /etc/shadow password fields are not empty (Automated)

echo "Checking for empty password fields in /etc/shadow..."

# Check for empty password fields
empty_passwords=$(awk -F: '($2 == "") {print $1}' /etc/shadow)

if [ -z "$empty_passwords" ]; then
    echo "PASS: No accounts with empty passwords found"
    exit 0
else
    echo "FAIL: Found accounts with empty passwords:"
    echo "$empty_passwords"
    exit 1
fi
