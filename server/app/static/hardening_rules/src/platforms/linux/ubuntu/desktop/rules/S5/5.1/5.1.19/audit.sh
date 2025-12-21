#!/bin/bash

# Check sshd PermitEmptyPasswords configuration
result=$(sshd -T 2>/dev/null | grep -i '^permitemptypasswords')

if echo "$result" | grep -qi "permitemptypasswords no"; then
    echo "PASS: PermitEmptyPasswords is disabled"
    exit 0
else
    echo "FAIL: PermitEmptyPasswords is not disabled"
    echo "  Expected: permitemptypasswords no"
    echo "  Actual: $result"
    exit 1
fi
