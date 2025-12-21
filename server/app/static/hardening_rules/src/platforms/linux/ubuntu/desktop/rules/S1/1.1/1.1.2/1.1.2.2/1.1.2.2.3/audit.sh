#!/bin/bash
if mount | grep " on /dev/shm " | grep -q "nosuid"; then
    echo "nosuid is set on /dev/shm"
    exit 0
else
    echo "nosuid is NOT set on /dev/shm"
    exit 1
fi
