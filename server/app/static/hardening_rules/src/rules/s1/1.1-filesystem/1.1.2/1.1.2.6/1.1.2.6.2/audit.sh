#!/bin/bash
if mount | grep " on /var/log " | grep -q "nodev"; then
    echo "nodev is set on /var/log"
    exit 0
else
    echo "nodev is NOT set on /var/log"
    exit 1
fi
