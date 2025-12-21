#!/bin/bash

# Check if root lockout is configured
even_deny=$(grep -Pi -- '^\h*even_deny_root\b' /etc/security/faillock.conf 2>/dev/null)
root_time=$(grep -Pi -- '^\h*root_unlock_time\h*=' /etc/security/faillock.conf 2>/dev/null)

if [ -n "$even_deny" ]; then
    if [ -n "$root_time" ]; then
        time=$(echo "$root_time" | grep -oP 'root_unlock_time\h*=\h*\K[0-9]+')
        if [ "$time" -ge 60 ]; then
            echo "PASS: Root lockout configured (even_deny_root, root_unlock_time = $time)"
            exit 0
        else
            echo "FAIL: root_unlock_time too short: $time seconds (should be >= 60)"
            exit 1
        fi
    else
        echo "PASS: Root lockout configured (even_deny_root, no root_unlock_time - permanent lock)"
        exit 0
    fi
else
    echo "FAIL: Root lockout (even_deny_root) is not configured"
    exit 1
fi
