#!/bin/bash

# Check if pam_unix includes use_authtok
result=$(grep -Pi -- '^\h*password\h+[^#\n\r]+\h+pam_unix\.so\b.*\buse_authtok\b' /etc/pam.d/common-password 2>/dev/null)

if [ -n "$result" ]; then
    echo "PASS: pam_unix includes use_authtok"
    echo "$result"
    exit 0
else
    echo "FAIL: pam_unix does not include use_authtok"
    exit 1
fi
