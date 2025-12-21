#!/bin/bash
if mount | grep " on /var/tmp " | grep -q "noexec"; then
    echo "noexec is set on /var/tmp"
    exit 0
else
    echo "noexec is NOT set on /var/tmp"
    exit 1
fi
