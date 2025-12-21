#!/bin/bash

# Check if pam_unix includes remember
result=$(grep -Pi -- '^\h*password\h+[^#\n\r]+\h+pam_unix\.so\b.*\bremember=' /etc/pam.d/common-password 2>/dev/null)

if [ -z "$result" ]; then
    echo "PASS: pam_unix does not include remember"
    exit 0
else
    echo "FAIL: pam_unix includes remember (should use pam_pwhistory instead)"
    echo "$result"
    exit 1
fi
