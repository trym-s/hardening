#!/bin/bash

# Check sshd LoginGraceTime configuration
result=$(sshd -T 2>/dev/null | grep -i '^logingracetime')
time=$(echo "$result" | awk '{print $2}')

if [ -n "$time" ] && [ "$time" -le 60 ] && [ "$time" -gt 0 ]; then
    echo "PASS: LoginGraceTime is configured correctly: $time seconds"
    exit 0
else
    echo "FAIL: LoginGraceTime is not configured correctly"
    echo "  Expected: 60 seconds or less"
    echo "  Actual: $result"
    exit 1
fi
