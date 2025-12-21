#!/bin/bash

# Verify nosuid option for /tmp mount
mount_opts=$(findmnt -n -o OPTIONS /tmp 2>/dev/null || true)

if echo "${mount_opts}" | grep -qw nosuid; then
    echo "PASS: /tmp is mounted with nosuid"
    exit 0
else
    echo "FAIL: /tmp is NOT mounted with nosuid"
    exit 1
fi
