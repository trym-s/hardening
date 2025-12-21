#!/bin/bash

# 6.1.3.4 Ensure rsyslog log file creation mode is configured (Automated)

echo "Configuring rsyslog log file creation mode..."

# Add FileCreateMode setting to rsyslog.conf if not present
if ! grep -q '^\$FileCreateMode' /etc/rsyslog.conf; then
    echo '$FileCreateMode 0640' >> /etc/rsyslog.conf
else
    sed -i 's/^\$FileCreateMode.*/$FileCreateMode 0640/' /etc/rsyslog.conf
fi

systemctl restart rsyslog

echo "rsyslog log file creation mode has been configured to 0640"
