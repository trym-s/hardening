#!/bin/bash

# Check sudo authentication timeout
result=$(grep -rPi -- '^\h*Defaults\h+([^#]+,\h*)?timestamp_timeout\h*=' /etc/sudoers* 2>/dev/null)

if [ -n "$result" ]; then
    timeout=$(echo "$result" | grep -oP 'timestamp_timeout\h*=\h*\K[0-9]+' | head -1)
    if [ -n "$timeout" ] && [ "$timeout" -le 15 ]; then
        echo "PASS: sudo timeout is configured correctly: $timeout minutes"
        exit 0
    else
        echo "FAIL: sudo timeout is too long: $timeout minutes (should be 15 or less)"
        exit 1
    fi
else
    echo "FAIL: sudo timeout is not configured (using default of 15 minutes)"
    echo "  Consider explicitly setting timestamp_timeout for security"
    exit 1
fi
