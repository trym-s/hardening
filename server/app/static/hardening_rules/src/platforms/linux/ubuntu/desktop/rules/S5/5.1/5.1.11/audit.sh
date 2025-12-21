#!/bin/bash

# Check sshd KerberosAuthentication configuration
result=$(sshd -T 2>/dev/null | grep -i '^kerberosauthentication')

if echo "$result" | grep -qi "kerberosauthentication no"; then
    echo "PASS: KerberosAuthentication is disabled"
    exit 0
else
    echo "FAIL: KerberosAuthentication is not disabled"
    echo "  Expected: kerberosauthentication no"
    echo "  Actual: $result"
    exit 1
fi
