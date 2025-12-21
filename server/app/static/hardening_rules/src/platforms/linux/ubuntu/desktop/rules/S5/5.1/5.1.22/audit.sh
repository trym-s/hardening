#!/bin/bash

# Check sshd UsePAM configuration
result=$(sshd -T 2>/dev/null | grep -i '^usepam')

if echo "$result" | grep -qi "usepam yes"; then
    echo "PASS: UsePAM is enabled"
    exit 0
else
    echo "FAIL: UsePAM is not enabled"
    echo "  Expected: usepam yes"
    echo "  Actual: $result"
    exit 1
fi
