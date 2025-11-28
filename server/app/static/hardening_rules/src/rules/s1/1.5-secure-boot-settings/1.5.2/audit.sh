#!/bin/bash
if [ "$(stat -c "%a %u %g" /boot/grub/grub.cfg)" == "400 0 0" ]; then
    echo "Permissions on /boot/grub/grub.cfg are correct"
    exit 0
else
    echo "Permissions on /boot/grub/grub.cfg are INCORRECT"
    exit 1
fi
