#!/bin/bash
if mount | grep " on /var/log/audit " | grep -q "nosuid"; then
    echo "nosuid is set on /var/log/audit"
    exit 0
else
    echo "nosuid is NOT set on /var/log/audit"
    exit 1
fi
