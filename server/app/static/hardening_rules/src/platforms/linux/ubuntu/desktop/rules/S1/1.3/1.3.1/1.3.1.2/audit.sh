#!/bin/bash
if grep "^[[:space:]]*linux" /boot/grub/grub.cfg | grep -qv "apparmor=1"; then
    exit 1
else
    if grep "^[[:space:]]*linux" /boot/grub/grub.cfg | grep -qv "security=apparmor"; then
        exit 1
    else
        exit 0
    fi
fi