#!/bin/bash

# Check sshd HostbasedAuthentication configuration
result=$(sshd -T 2>/dev/null | grep -i '^hostbasedauthentication')

if echo "$result" | grep -qi "hostbasedauthentication no"; then
    echo "PASS: HostbasedAuthentication is disabled"
    exit 0
else
    echo "FAIL: HostbasedAuthentication is not disabled"
    echo "  Expected: hostbasedauthentication no"
    echo "  Actual: $result"
    exit 1
fi
