#!/bin/bash

# Remount /tmp with nodev
mount -o remount,nodev /tmp

# Update /etc/fstab to make it permanent
if grep -q "/tmp" /etc/fstab; then
    sed -i 's|\(/tmp.*defaults\)\(.*\)|\1,nodev\2|' /etc/fstab
    echo "Remediation applied: /tmp remounted with nodev and fstab updated."
else
    echo "WARNING: /tmp not found in /etc/fstab. Please configure it manually."
fi
