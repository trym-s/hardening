#!/bin/bash

# 6.1.2.4 Ensure journald Storage is configured (Automated)

echo "Configuring Storage in journald configuration..."

# Update or add Storage=persistent
if grep -q "^Storage=" /etc/systemd/journald.conf; then
    sed -i 's/^Storage=.*/Storage=persistent/' /etc/systemd/journald.conf
else
    sed -i '/^\[Journal\]/a Storage=persistent' /etc/systemd/journald.conf
fi

systemctl restart systemd-journald

echo "Storage has been configured to persistent"
