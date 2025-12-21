#!/bin/bash

# Verify noexec option for /tmp mount
mount_opts=$(findmnt -n -o OPTIONS /tmp 2>/dev/null || true)
if echo "${mount_opts}" | grep -qw "noexec"; then
    echo "PASS: /tmp is mounted with noexec"
    exit 0
else
    echo "FAIL: /tmp is NOT mounted with noexec"
    exit 1
fi
