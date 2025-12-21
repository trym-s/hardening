#!/bin/bash
if mount | grep " on /dev/shm " | grep -q "nodev"; then
    echo "nodev is set on /dev/shm"
    exit 0
else
    echo "nodev is NOT set on /dev/shm"
    exit 1
fi
