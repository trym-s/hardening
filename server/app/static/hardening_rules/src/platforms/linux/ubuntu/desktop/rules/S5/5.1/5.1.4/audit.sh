#!/bin/bash

# Check if sshd access is configured
result=$(sshd -T 2>/dev/null | grep -Pi -- '^\h*(allow|deny)(users|groups)\h+\H+')

if [ -n "$result" ]; then
    echo "PASS: sshd access control is configured:"
    echo "$result"
    exit 0
else
    echo "FAIL: No sshd access control configured"
    echo "  Configure at least one of: AllowUsers, AllowGroups, DenyUsers, or DenyGroups"
    exit 1
fi
