#!/bin/bash
if grep -q "apparmor=1" /etc/default/grub && grep -q "security=apparmor" /etc/default/grub; then
    echo "AppArmor is enabled in bootloader"
    exit 0
else
    echo "AppArmor is NOT enabled in bootloader"
    exit 1
fi
