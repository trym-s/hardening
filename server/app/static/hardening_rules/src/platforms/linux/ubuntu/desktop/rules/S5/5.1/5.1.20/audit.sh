#!/bin/bash

# Check sshd PermitRootLogin configuration
result=$(sshd -T 2>/dev/null | grep -i '^permitrootlogin')

if echo "$result" | grep -qi "permitrootlogin no"; then
    echo "PASS: PermitRootLogin is disabled"
    exit 0
else
    echo "FAIL: PermitRootLogin is not disabled"
    echo "  Expected: permitrootlogin no"
    echo "  Actual: $result"
    exit 1
fi
