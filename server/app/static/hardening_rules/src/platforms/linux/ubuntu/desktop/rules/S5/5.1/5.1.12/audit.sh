#!/bin/bash

# Check sshd KexAlgorithms configuration
weak_kex="diffie-hellman-group1-sha1|diffie-hellman-group14-sha1|diffie-hellman-group-exchange-sha1"
result=$(sshd -T 2>/dev/null | grep -i '^kexalgorithms')

if echo "$result" | grep -qE "$weak_kex"; then
    echo "FAIL: Weak key exchange algorithms detected"
    echo "  $result"
    exit 1
elif [ -z "$result" ]; then
    echo "FAIL: No KexAlgorithms configured"
    exit 1
else
    echo "PASS: KexAlgorithms configured"
    echo "  $result"
    exit 0
fi
