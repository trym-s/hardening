#!/bin/bash

# Check password hashing algorithm
result=$(grep -Pi -- '^\h*password\h+[^#\n\r]+\h+pam_unix\.so\b' /etc/pam.d/common-password 2>/dev/null)

if echo "$result" | grep -qE '(sha512|yescrypt)'; then
    echo "PASS: Strong password hashing algorithm configured"
    echo "$result"
    exit 0
else
    echo "FAIL: Strong password hashing algorithm not configured"
    echo "  Expected: sha512 or yescrypt"
    echo "  Actual: $result"
    exit 1
fi
