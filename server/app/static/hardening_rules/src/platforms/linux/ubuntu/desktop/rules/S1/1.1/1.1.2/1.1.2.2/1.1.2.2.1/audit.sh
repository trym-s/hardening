#!/bin/bash
if mountpoint -q /dev/shm; then
    echo "/dev/shm is a separate partition"
    exit 0
else
    echo "/dev/shm is NOT a separate partition"
    exit 1
fi
