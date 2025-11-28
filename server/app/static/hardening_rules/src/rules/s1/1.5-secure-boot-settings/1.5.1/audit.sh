#!/bin/bash
if grep -q "^set superusers" /boot/grub/grub.cfg; then
    echo "Bootloader password is set"
    exit 0
else
    echo "Bootloader password is NOT set"
    exit 1
fi
