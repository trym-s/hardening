#!/bin/bash
if mount | grep " on /var " | grep -q "nodev"; then
    echo "nodev is set on /var"
    exit 0
else
    echo "nodev is NOT set on /var"
    exit 1
fi
