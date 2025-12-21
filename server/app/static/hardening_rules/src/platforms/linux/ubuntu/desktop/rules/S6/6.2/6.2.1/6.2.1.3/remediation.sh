#!/bin/bash

# 6.2.1.3 Ensure auditing for processes that start prior to auditd is enabled (Automated)

echo "Enabling auditing for processes that start prior to auditd..."

# Add audit=1 to GRUB_CMDLINE_LINUX
if grep -q "^GRUB_CMDLINE_LINUX=" /etc/default/grub; then
    if ! grep "^GRUB_CMDLINE_LINUX=" /etc/default/grub | grep -q "audit=1"; then
        sed -i 's/^GRUB_CMDLINE_LINUX="/&audit=1 /' /etc/default/grub
    fi
else
    echo 'GRUB_CMDLINE_LINUX="audit=1"' >> /etc/default/grub
fi

# Update GRUB
update-grub

echo "audit=1 has been added to kernel boot parameters"
echo "System reboot required for changes to take effect"
