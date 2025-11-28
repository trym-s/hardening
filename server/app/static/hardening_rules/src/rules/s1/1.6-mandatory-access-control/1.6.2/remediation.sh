#!/bin/bash
# Add apparmor=1 and security=apparmor to GRUB_CMDLINE_LINUX
if grep -q "GRUB_CMDLINE_LINUX=" /etc/default/grub; then
    sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 apparmor=1 security=apparmor"/' /etc/default/grub
else
    echo 'GRUB_CMDLINE_LINUX="apparmor=1 security=apparmor"' >> /etc/default/grub
fi
update-grub
