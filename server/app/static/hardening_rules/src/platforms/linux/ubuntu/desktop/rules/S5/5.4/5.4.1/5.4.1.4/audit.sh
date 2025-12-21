#!/bin/bash

# CIS 5.4.1.4 - Ensure strong password hashing algorithm is configured
# Check ENCRYPT_METHOD in /etc/login.defs

echo "Checking password hashing algorithm configuration..."

# Check /etc/login.defs for ENCRYPT_METHOD
encrypt_method=$(grep -Pi -- '^\h*ENCRYPT_METHOD\h+(SHA512|yescrypt)\b' /etc/login.defs)

if [ -z "$encrypt_method" ]; then
    current=$(grep -Pi -- '^\h*ENCRYPT_METHOD\h+' /etc/login.defs | awk '{print $2}')
    if [ -n "$current" ]; then
        echo "FAIL: ENCRYPT_METHOD is set to $current (should be SHA512 or YESCRYPT)"
    else
        echo "FAIL: ENCRYPT_METHOD is not set in /etc/login.defs"
    fi
    exit 1
fi

echo "PASS: Strong password hashing algorithm is configured"
echo "$encrypt_method"
exit 0
