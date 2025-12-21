#!/bin/bash

# Check sshd IgnoreRhosts configuration
result=$(sshd -T 2>/dev/null | grep -i '^ignorerhosts')

if echo "$result" | grep -qi "ignorerhosts yes"; then
    echo "PASS: IgnoreRhosts is enabled"
    exit 0
else
    echo "FAIL: IgnoreRhosts is not enabled"
    echo "  Expected: ignorerhosts yes"
    echo "  Actual: $result"
    exit 1
fi
