#!/bin/bash

# Configure sudo timeout
echo "Configuring sudo authentication timeout..."

if grep -rPi -- '^\h*Defaults\h+([^#]+,\h*)?timestamp_timeout\h*=' /etc/sudoers* &>/dev/null; then
    echo "INFO: timestamp_timeout already configured"
    grep -rPi -- '^\h*Defaults\h+([^#]+,\h*)?timestamp_timeout\h*=' /etc/sudoers*
else
    echo 'Defaults timestamp_timeout=15' > /etc/sudoers.d/timeout
    chmod 440 /etc/sudoers.d/timeout
    echo "SUCCESS: Configured sudo timeout to 15 minutes"
fi
