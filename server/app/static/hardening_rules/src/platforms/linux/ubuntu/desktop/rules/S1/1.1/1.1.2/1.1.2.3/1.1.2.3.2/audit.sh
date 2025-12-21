#!/bin/bash
if mount | grep " on /home " | grep -q "nodev"; then
    echo "nodev is set on /home"
    exit 0
else
    echo "nodev is NOT set on /home"
    exit 1
fi
