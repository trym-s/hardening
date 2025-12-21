#!/bin/bash
if mount | grep " on /var " | grep -q "nosuid"; then
    echo "nosuid is set on /var"
    exit 0
else
    echo "nosuid is NOT set on /var"
    exit 1
fi
