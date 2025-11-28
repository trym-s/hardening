#!/bin/bash

# Verify nodev option for /tmp mount
mound_opts=$(findmnt -n -o OPTIONS /tmp 2>/dev/null || true)

if echo "${mound_opts}" | grep -qw "nodev"; then
    echo "PASS: /tmp is mounted with nodev"
    exit 0
else
    echo "FAIL: /tmp is NOT mounted with nodev"
    exit 1
fi
