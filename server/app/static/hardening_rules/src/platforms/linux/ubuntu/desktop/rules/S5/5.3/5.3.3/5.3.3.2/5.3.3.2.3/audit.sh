#!/bin/bash

# Check password complexity
minclass=$(grep -Pi -- '^\h*minclass\h*=' /etc/security/pwquality.conf 2>/dev/null)
credits=$(grep -Pi -- '^\h*[dulo]credit\h*=' /etc/security/pwquality.conf 2>/dev/null)

if [ -n "$minclass" ] || [ -n "$credits" ]; then
    echo "PASS: Password complexity is configured:"
    [ -n "$minclass" ] && echo "$minclass"
    [ -n "$credits" ] && echo "$credits"
    exit 0
else
    echo "FAIL: Password complexity is not configured"
    echo "  Configure minclass or dcredit/ucredit/lcredit/ocredit"
    exit 1
fi
