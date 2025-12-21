#!/bin/bash

# Remediate sshd GSSAPIAuthentication configuration
echo "Disabling sshd GSSAPIAuthentication..."

# Remove any existing GSSAPIAuthentication directive
sed -i '/^GSSAPIAuthentication\s/d' /etc/ssh/sshd_config

# Add GSSAPIAuthentication directive
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: GSSAPIAuthentication disabled"
