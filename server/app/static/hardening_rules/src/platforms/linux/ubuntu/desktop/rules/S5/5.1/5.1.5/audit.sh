#!/bin/bash

# Check if sshd Banner is configured
result=$(sshd -T 2>/dev/null | grep -i '^banner')

if echo "$result" | grep -q 'banner /'; then
    echo "PASS: sshd Banner is configured"
    echo "  $result"
    exit 0
else
    echo "FAIL: sshd Banner is not configured"
    echo "  Expected: banner <path>"
    echo "  Actual: $result"
    exit 1
fi
