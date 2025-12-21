#!/bin/bash

# Check password history remember
result=$(grep -Pi -- '^\h*remember\h*=' /etc/security/pwhistory.conf 2>/dev/null)

if [ -n "$result" ]; then
    remember=$(echo "$result" | grep -oP 'remember\h*=\h*\K[0-9]+')
    if [ "$remember" -ge 24 ]; then
        echo "PASS: Password history configured: remember = $remember"
        exit 0
    else
        echo "FAIL: Password history too low: $remember (should be >= 24)"
        exit 1
    fi
else
    echo "FAIL: Password history (remember) is not configured"
    exit 1
fi
