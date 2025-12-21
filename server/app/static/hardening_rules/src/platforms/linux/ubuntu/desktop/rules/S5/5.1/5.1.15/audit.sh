#!/bin/bash

# Check sshd MACs configuration
weak_macs="hmac-md5|hmac-md5-96|hmac-ripemd160|hmac-sha1-96|umac-64|hmac-md5-etm|hmac-md5-96-etm|hmac-ripemd160-etm|hmac-sha1-96-etm|umac-64-etm|umac-128-etm"
result=$(sshd -T 2>/dev/null | grep -i '^macs')

if echo "$result" | grep -qE "$weak_macs"; then
    echo "FAIL: Weak MACs detected"
    echo "  $result"
    exit 1
elif [ -z "$result" ]; then
    echo "FAIL: No MACs configured"
    exit 1
else
    echo "PASS: MACs configured"
    echo "  $result"
    exit 0
fi
