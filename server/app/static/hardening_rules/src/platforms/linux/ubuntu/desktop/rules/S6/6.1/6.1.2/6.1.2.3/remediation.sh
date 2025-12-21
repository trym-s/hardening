#!/bin/bash

# 6.1.2.3 Ensure journald Compress is configured (Automated)

echo "Enabling Compress in journald configuration..."

# Update or add Compress=yes
if grep -q "^Compress=" /etc/systemd/journald.conf; then
    sed -i 's/^Compress=.*/Compress=yes/' /etc/systemd/journald.conf
else
    sed -i '/^\[Journal\]/a Compress=yes' /etc/systemd/journald.conf
fi

systemctl restart systemd-journald

echo "Compress has been enabled"
