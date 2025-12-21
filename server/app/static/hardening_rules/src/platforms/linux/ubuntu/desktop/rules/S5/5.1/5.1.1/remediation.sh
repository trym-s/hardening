#!/bin/bash

# Remediate permissions on /etc/ssh/sshd_config
echo "Setting permissions on /etc/ssh/sshd_config..."

if [ -f /etc/ssh/sshd_config ]; then
    chown root:root /etc/ssh/sshd_config
    chmod 600 /etc/ssh/sshd_config
    echo "SUCCESS: Permissions set to 600, owner set to root:root"
else
    echo "ERROR: /etc/ssh/sshd_config not found"
    return 1
fi
