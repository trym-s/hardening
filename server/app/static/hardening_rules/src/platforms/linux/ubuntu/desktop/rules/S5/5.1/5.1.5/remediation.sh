#!/bin/bash

# Remediate sshd Banner configuration
echo "Configuring sshd Banner..."

# Remove any existing Banner directive
sed -i '/^Banner\s/d' /etc/ssh/sshd_config

# Add Banner directive
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: Banner configured to /etc/issue.net"
