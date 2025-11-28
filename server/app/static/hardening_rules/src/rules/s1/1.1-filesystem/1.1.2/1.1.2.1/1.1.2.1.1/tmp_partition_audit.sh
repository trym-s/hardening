#!/bin/bash

# Check if /tmp is a separate partition
if mountpoint -q /tmp; then
    echo "PASS: /tmp is a separate partition"
    exit 0
else
    echo "FAIL: /tmp is NOT a separate partition"
    exit 1
fi
