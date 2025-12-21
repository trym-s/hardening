#!/bin/bash

# Check if access to su command is restricted
result=$(grep -Pi -- '^\h*auth\h+\H+\h+pam_wheel\.so\h+' /etc/pam.d/su 2>/dev/null)

if echo "$result" | grep -q 'use_uid' && echo "$result" | grep -q 'group='; then
    echo "PASS: Access to su command is restricted"
    echo "$result"
    exit 0
else
    echo "FAIL: Access to su command is not properly restricted"
    echo "  Expected: auth required pam_wheel.so use_uid group=<groupname>"
    echo "  Actual: $result"
    exit 1
fi
