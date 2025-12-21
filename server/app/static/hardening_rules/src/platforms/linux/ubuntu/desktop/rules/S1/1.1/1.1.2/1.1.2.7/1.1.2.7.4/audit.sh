#!/bin/bash
if mount | grep " on /var/log/audit " | grep -q "noexec"; then
    echo "noexec is set on /var/log/audit"
    exit 0
else
    echo "noexec is NOT set on /var/log/audit"
    exit 1
fi
