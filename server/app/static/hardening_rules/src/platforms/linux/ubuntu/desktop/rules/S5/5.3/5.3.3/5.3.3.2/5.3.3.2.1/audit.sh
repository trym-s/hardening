#!/bin/bash

# Check password changed characters
result=$(grep -Pi -- '^\h*difok\h*=' /etc/security/pwquality.conf 2>/dev/null)

if [ -n "$result" ]; then
    difok=$(echo "$result" | grep -oP 'difok\h*=\h*\K[0-9]+')
    if [ "$difok" -ge 2 ]; then
        echo "PASS: difok is configured: $difok"
        exit 0
    else
        echo "FAIL: difok is too low: $difok (should be >= 2)"
        exit 1
    fi
else
    echo "FAIL: difok is not configured"
    exit 1
fi
