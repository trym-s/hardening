#!/bin/bash

# Remediate sshd PermitRootLogin configuration
echo "Disabling sshd PermitRootLogin..."

# Remove any existing PermitRootLogin directive
sed -i '/^PermitRootLogin\s/d' /etc/ssh/sshd_config

# Add PermitRootLogin directive
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: PermitRootLogin disabled"
