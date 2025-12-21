#!/bin/bash

# Check sshd PermitUserEnvironment configuration
result=$(sshd -T 2>/dev/null | grep -i '^permituserenvironment')

if echo "$result" | grep -qi "permituserenvironment no"; then
    echo "PASS: PermitUserEnvironment is disabled"
    exit 0
else
    echo "FAIL: PermitUserEnvironment is not disabled"
    echo "  Expected: permituserenvironment no"
    echo "  Actual: $result"
    exit 1
fi
