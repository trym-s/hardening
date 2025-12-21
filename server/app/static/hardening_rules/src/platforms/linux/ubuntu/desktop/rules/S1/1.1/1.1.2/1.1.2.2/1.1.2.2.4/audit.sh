#!/bin/bash
if mount | grep " on /dev/shm " | grep -q "noexec"; then
    echo "noexec is set on /dev/shm"
    exit 0
else
    echo "noexec is NOT set on /dev/shm"
    exit 1
fi
