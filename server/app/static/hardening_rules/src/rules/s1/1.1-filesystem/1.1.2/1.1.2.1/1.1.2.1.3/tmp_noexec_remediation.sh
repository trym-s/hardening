#!/bin/bash

# Remount /tmp with noexec
mount -o remount,noexec /tmp

# Update /etc/fstab to make it permanent
if grep -q "/tmp" /etc/fstab; then
    sed -i 's|\(/tmp.*defaults\)\(.*\)|\1,noexec\2|' /etc/fstab
    echo "Remediation applied: /tmp remounted with noexec and fstab updated."
else
    echo "WARNING: /tmp not found in /etc/fstab. Please configure it manually."
fi
