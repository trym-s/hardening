#!/bin/bash

# Check password quality enforcement
result=$(grep -Pi -- '^\h*enforcing\h*=\h*0' /etc/security/pwquality.conf 2>/dev/null)

if [ -z "$result" ]; then
    echo "PASS: Password quality enforcing is enabled"
    exit 0
else
    echo "FAIL: Password quality enforcing is disabled"
    exit 1
fi
