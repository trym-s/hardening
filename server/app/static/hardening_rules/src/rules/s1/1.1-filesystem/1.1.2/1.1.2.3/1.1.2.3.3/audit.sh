#!/bin/bash
if mount | grep " on /home " | grep -q "nosuid"; then
    echo "nosuid is set on /home"
    exit 0
else
    echo "nosuid is NOT set on /home"
    exit 1
fi
