#!/bin/bash

# Check sshd MaxAuthTries configuration
result=$(sshd -T 2>/dev/null | grep -i '^maxauthtries')
tries=$(echo "$result" | awk '{print $2}')

if [ -n "$tries" ] && [ "$tries" -le 4 ] && [ "$tries" -gt 0 ]; then
    echo "PASS: MaxAuthTries is configured correctly: $tries"
    exit 0
else
    echo "FAIL: MaxAuthTries is not configured correctly"
    echo "  Expected: 4 or less"
    echo "  Actual: $result"
    exit 1
fi
