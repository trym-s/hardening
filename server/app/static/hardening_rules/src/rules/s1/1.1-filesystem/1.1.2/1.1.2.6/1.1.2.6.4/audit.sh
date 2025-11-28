#!/bin/bash
if mount | grep " on /var/log " | grep -q "noexec"; then
    echo "noexec is set on /var/log"
    exit 0
else
    echo "noexec is NOT set on /var/log"
    exit 1
fi
