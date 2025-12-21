#!/bin/bash

# Check sshd DisableForwarding configuration
result=$(sshd -T 2>/dev/null | grep -i '^disableforwarding')

if echo "$result" | grep -qi "disableforwarding yes"; then
    echo "PASS: DisableForwarding is enabled"
    exit 0
else
    echo "FAIL: DisableForwarding is not enabled"
    echo "  Expected: disableforwarding yes"
    echo "  Actual: $result"
    exit 1
fi
