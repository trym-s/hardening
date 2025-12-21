#!/bin/bash

# Check sshd GSSAPIAuthentication configuration
result=$(sshd -T 2>/dev/null | grep -i '^gssapiauthentication')

if echo "$result" | grep -qi "gssapiauthentication no"; then
    echo "PASS: GSSAPIAuthentication is disabled"
    exit 0
else
    echo "FAIL: GSSAPIAuthentication is not disabled"
    echo "  Expected: gssapiauthentication no"
    echo "  Actual: $result"
    exit 1
fi
