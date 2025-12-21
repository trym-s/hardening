#!/bin/bash

# Check sshd MaxSessions configuration
result=$(sshd -T 2>/dev/null | grep -i '^maxsessions')
sessions=$(echo "$result" | awk '{print $2}')

if [ -n "$sessions" ] && [ "$sessions" -le 10 ] && [ "$sessions" -gt 0 ]; then
    echo "PASS: MaxSessions is configured correctly: $sessions"
    exit 0
else
    echo "FAIL: MaxSessions is not configured correctly"
    echo "  Expected: 10 or less"
    echo "  Actual: $result"
    exit 1
fi
