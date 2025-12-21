#!/bin/bash

# Check sshd MaxStartups configuration
result=$(sshd -T 2>/dev/null | grep -i '^maxstartups')

if echo "$result" | grep -qE "maxstartups [0-9]+:[0-9]+:[0-9]+"; then
    echo "PASS: MaxStartups is configured"
    echo "  $result"
    exit 0
else
    echo "FAIL: MaxStartups is not configured correctly"
    echo "  Expected: maxstartups <start>:<rate>:<full> (e.g., 10:30:60)"
    echo "  Actual: $result"
    exit 1
fi
