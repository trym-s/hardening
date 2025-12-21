#!/bin/bash

# Check minimum password length
result=$(grep -Pi -- '^\h*minlen\h*=' /etc/security/pwquality.conf 2>/dev/null)

if [ -n "$result" ]; then
    minlen=$(echo "$result" | grep -oP 'minlen\h*=\h*\K[0-9]+')
    if [ "$minlen" -ge 14 ]; then
        echo "PASS: minlen is configured: $minlen"
        exit 0
    else
        echo "FAIL: minlen is too low: $minlen (should be >= 14)"
        exit 1
    fi
else
    echo "FAIL: minlen is not configured"
    exit 1
fi
