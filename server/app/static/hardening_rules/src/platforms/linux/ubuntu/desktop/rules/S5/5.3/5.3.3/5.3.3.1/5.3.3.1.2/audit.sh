#!/bin/bash

# Check password unlock time
result=$(grep -Pi -- '^\h*unlock_time\h*=' /etc/security/faillock.conf 2>/dev/null)

if [ -n "$result" ]; then
    time=$(echo "$result" | grep -oP 'unlock_time\h*=\h*\K[0-9]+')
    if [ "$time" -eq 0 ] || [ "$time" -ge 900 ]; then
        echo "PASS: Password unlock time configured: $time seconds"
        exit 0
    else
        echo "FAIL: Password unlock time too short: $time seconds (should be 0 or >= 900)"
        exit 1
    fi
else
    echo "FAIL: Password unlock time is not configured"
    exit 1
fi
