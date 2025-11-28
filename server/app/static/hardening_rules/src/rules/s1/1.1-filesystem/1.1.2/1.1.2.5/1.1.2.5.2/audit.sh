#!/bin/bash
if mount | grep " on /var/tmp " | grep -q "nodev"; then
    echo "nodev is set on /var/tmp"
    exit 0
else
    echo "nodev is NOT set on /var/tmp"
    exit 1
fi
