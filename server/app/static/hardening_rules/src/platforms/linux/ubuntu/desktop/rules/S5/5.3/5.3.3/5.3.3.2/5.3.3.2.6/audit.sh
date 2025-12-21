#!/bin/bash

# Check password dictionary check
result=$(grep -Pi -- '^\h*dictcheck\h*=\h*0' /etc/security/pwquality.conf 2>/dev/null)

if [ -z "$result" ]; then
    echo "PASS: dictcheck is enabled (not set to 0)"
    exit 0
else
    echo "FAIL: dictcheck is disabled (set to 0)"
    exit 1
fi
