#!/bin/bash

# Remediate sshd HostbasedAuthentication configuration
echo "Disabling sshd HostbasedAuthentication..."

# Remove any existing HostbasedAuthentication directive
sed -i '/^HostbasedAuthentication\s/d' /etc/ssh/sshd_config

# Add HostbasedAuthentication directive
echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: HostbasedAuthentication disabled"
