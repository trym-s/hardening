#!/bin/bash

# Check if users must provide password for privilege escalation
nopasswd=$(grep -rPi -- '^\h*([^#\n\r]+)?NOPASSWD' /etc/sudoers* 2>/dev/null)

if [ -z "$nopasswd" ]; then
    echo "PASS: No NOPASSWD entries found - password required for privilege escalation"
    exit 0
else
    echo "FAIL: NOPASSWD entries found - users can escalate without password"
    echo "$nopasswd"
    exit 1
fi
