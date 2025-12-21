#!/bin/bash

# Check sshd LogLevel configuration
result=$(sshd -T 2>/dev/null | grep -i '^loglevel')

if echo "$result" | grep -qiE "loglevel (VERBOSE|INFO)"; then
    echo "PASS: LogLevel is configured correctly"
    echo "  $result"
    exit 0
else
    echo "FAIL: LogLevel is not configured correctly"
    echo "  Expected: VERBOSE or INFO"
    echo "  Actual: $result"
    exit 1
fi
