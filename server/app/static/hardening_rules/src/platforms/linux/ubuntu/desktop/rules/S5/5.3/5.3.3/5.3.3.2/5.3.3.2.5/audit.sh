#!/bin/bash

# Check password maximum sequential characters
result=$(grep -Pi -- '^\h*maxsequence\h*=' /etc/security/pwquality.conf 2>/dev/null)

if [ -n "$result" ]; then
    maxseq=$(echo "$result" | grep -oP 'maxsequence\h*=\h*\K[0-9]+')
    if [ "$maxseq" -le 3 ] && [ "$maxseq" -gt 0 ]; then
        echo "PASS: maxsequence is configured: $maxseq"
        exit 0
    else
        echo "FAIL: maxsequence is too high: $maxseq (should be <= 3)"
        exit 1
    fi
else
    echo "FAIL: maxsequence is not configured"
    exit 1
fi
