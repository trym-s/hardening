#!/bin/bash
if mount | grep " on /var/log " | grep -q "nosuid"; then
    echo "nosuid is set on /var/log"
    exit 0
else
    echo "nosuid is NOT set on /var/log"
    exit 1
fi
