#!/bin/bash

# Check password failed attempts lockout
result=$(grep -Pi -- '^\h*deny\h*=' /etc/security/faillock.conf 2>/dev/null)

if [ -n "$result" ]; then
    deny=$(echo "$result" | grep -oP 'deny\h*=\h*\K[0-9]+')
    if [ "$deny" -le 5 ] && [ "$deny" -gt 0 ]; then
        echo "PASS: Password lockout configured: deny = $deny"
        exit 0
    else
        echo "FAIL: Password lockout too high: deny = $deny (should be 5 or less)"
        exit 1
    fi
else
    echo "FAIL: Password lockout (deny) is not configured"
    exit 1
fi
