#!/bin/bash

# Check if root is subject to password history
result=$(grep -Pi -- '^\h*enforce_for_root\b' /etc/security/pwhistory.conf 2>/dev/null)

if [ -n "$result" ]; then
    echo "PASS: Password history is enforced for root"
    exit 0
else
    echo "FAIL: Password history is not enforced for root"
    exit 1
fi
