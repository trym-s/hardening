#!/bin/bash

# 6.2.1.4 Ensure audit_backlog_limit is sufficient (Automated)

echo "Setting audit_backlog_limit to 8192..."

# Add audit_backlog_limit=8192 to GRUB_CMDLINE_LINUX
if grep -q "^GRUB_CMDLINE_LINUX=" /etc/default/grub; then
    if ! grep "^GRUB_CMDLINE_LINUX=" /etc/default/grub | grep -q "audit_backlog_limit="; then
        sed -i 's/^GRUB_CMDLINE_LINUX="/&audit_backlog_limit=8192 /' /etc/default/grub
    else
        sed -i 's/audit_backlog_limit=[0-9]*/audit_backlog_limit=8192/' /etc/default/grub
    fi
else
    echo 'GRUB_CMDLINE_LINUX="audit_backlog_limit=8192"' >> /etc/default/grub
fi

# Update GRUB
update-grub

echo "audit_backlog_limit has been set to 8192"
echo "System reboot required for changes to take effect"
