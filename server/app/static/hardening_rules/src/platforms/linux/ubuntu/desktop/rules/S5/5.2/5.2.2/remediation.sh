#!/bin/bash

# Configure sudo to use pty
echo "Configuring sudo to use pty..."

if grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,)?use_pty' /etc/sudoers* &>/dev/null; then
    echo "INFO: use_pty already configured"
else
    echo "Defaults use_pty" > /etc/sudoers.d/use_pty
    chmod 440 /etc/sudoers.d/use_pty
    echo "SUCCESS: Configured sudo to use pty"
fi
