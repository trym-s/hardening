#!/bin/bash

# Configure sudo log file
echo "Configuring sudo log file..."

if grep -rPsi -- '^\h*Defaults\h+([^#]+,\h*)?logfile\h*=' /etc/sudoers* &>/dev/null; then
    echo "INFO: sudo log file already configured"
else
    echo 'Defaults logfile="/var/log/sudo.log"' > /etc/sudoers.d/logfile
    chmod 440 /etc/sudoers.d/logfile
    echo "SUCCESS: Configured sudo log file to /var/log/sudo.log"
fi
