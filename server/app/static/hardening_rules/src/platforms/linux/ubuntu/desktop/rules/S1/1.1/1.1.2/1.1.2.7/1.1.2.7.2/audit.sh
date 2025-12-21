#!/bin/bash
if mount | grep " on /var/log/audit " | grep -q "nodev"; then
    echo "nodev is set on /var/log/audit"
    exit 0
else
    echo "nodev is NOT set on /var/log/audit"
    exit 1
fi
