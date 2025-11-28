#!/bin/bash

# Check if /tmp is mounted with noexec
if mount | grep "on /tmp" | grep -q "noexec"; then
    echo "PASS: /tmp is mounted with noexec"
    exit 0
else
    echo "FAIL: /tmp is NOT mounted with noexec"
    exit 1
fi
