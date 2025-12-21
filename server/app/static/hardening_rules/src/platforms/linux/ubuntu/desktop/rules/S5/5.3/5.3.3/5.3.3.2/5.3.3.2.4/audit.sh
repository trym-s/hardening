#!/bin/bash

# Check password same consecutive characters
result=$(grep -Pi -- '^\h*maxrepeat\h*=' /etc/security/pwquality.conf 2>/dev/null)

if [ -n "$result" ]; then
    maxrepeat=$(echo "$result" | grep -oP 'maxrepeat\h*=\h*\K[0-9]+')
    if [ "$maxrepeat" -le 3 ] && [ "$maxrepeat" -gt 0 ]; then
        echo "PASS: maxrepeat is configured: $maxrepeat"
        exit 0
    else
        echo "FAIL: maxrepeat is too high: $maxrepeat (should be <= 3)"
        exit 1
    fi
else
    echo "FAIL: maxrepeat is not configured"
    exit 1
fi
