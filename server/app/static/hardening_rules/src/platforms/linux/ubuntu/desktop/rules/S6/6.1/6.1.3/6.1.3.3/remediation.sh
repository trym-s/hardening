#!/bin/bash

# 6.1.3.3 Ensure journald is configured to send logs to rsyslog (Automated)

echo "Configuring journald to send logs to rsyslog..."

# Update or add ForwardToSyslog=yes
if grep -q "^ForwardToSyslog=" /etc/systemd/journald.conf; then
    sed -i 's/^ForwardToSyslog=.*/ForwardToSyslog=yes/' /etc/systemd/journald.conf
else
    sed -i '/^\[Journal\]/a ForwardToSyslog=yes' /etc/systemd/journald.conf
fi

systemctl restart systemd-journald

echo "journald has been configured to send logs to rsyslog"
