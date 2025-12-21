#!/bin/bash

# 6.1.2.2 Ensure journald ForwardToSyslog is disabled (Automated)

echo "Disabling ForwardToSyslog in journald configuration..."

# Update or add ForwardToSyslog=no
if grep -q "^ForwardToSyslog=" /etc/systemd/journald.conf; then
    sed -i 's/^ForwardToSyslog=.*/ForwardToSyslog=no/' /etc/systemd/journald.conf
else
    sed -i '/^\[Journal\]/a ForwardToSyslog=no' /etc/systemd/journald.conf
fi

systemctl restart systemd-journald

echo "ForwardToSyslog has been disabled"
