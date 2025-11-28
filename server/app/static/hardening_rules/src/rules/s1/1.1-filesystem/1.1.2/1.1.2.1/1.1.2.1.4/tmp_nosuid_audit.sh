#!/bin/bash

# Check if /tmp is mounted with nosuid
if mount | grep "on /tmp" | grep -q "nosuid"; then
    echo "PASS: /tmp is mounted with nosuid"
    exit 0
else
    echo "FAIL: /tmp is NOT mounted with nosuid"
    exit 1
fi
