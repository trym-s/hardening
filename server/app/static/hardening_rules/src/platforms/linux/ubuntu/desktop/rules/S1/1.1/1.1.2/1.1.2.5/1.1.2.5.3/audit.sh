#!/bin/bash
if mount | grep " on /var/tmp " | grep -q "nosuid"; then
    echo "nosuid is set on /var/tmp"
    exit 0
else
    echo "nosuid is NOT set on /var/tmp"
    exit 1
fi
