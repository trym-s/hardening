#!/bin/bash

# Check if root is subject to password quality
result=$(grep -Pi -- '^\h*enforce_for_root\b' /etc/security/pwquality.conf 2>/dev/null)

if [ -n "$result" ]; then
    echo "PASS: Password quality is enforced for root"
    exit 0
else
    echo "FAIL: Password quality is not enforced for root"
    exit 1
fi
