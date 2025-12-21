#!/bin/bash

# Check if pam_pwhistory includes use_authtok
result=$(grep -Pi -- '^\h*password\h+[^#\n\r]+\h+pam_pwhistory\.so\h+[^#\n\r]*\buse_authtok\b' /etc/pam.d/common-password 2>/dev/null)

if [ -n "$result" ]; then
    echo "PASS: pam_pwhistory includes use_authtok"
    echo "$result"
    exit 0
else
    # Check pwhistory.conf as well
    if grep -qi '^use_authtok' /etc/security/pwhistory.conf 2>/dev/null; then
        echo "PASS: use_authtok configured in pwhistory.conf"
        exit 0
    fi
    echo "FAIL: pam_pwhistory does not include use_authtok"
    exit 1
fi
