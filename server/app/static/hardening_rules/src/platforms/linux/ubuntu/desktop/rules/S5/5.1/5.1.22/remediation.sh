#!/bin/bash

# Remediate sshd UsePAM configuration
echo "Enabling sshd UsePAM..."

# Remove any existing UsePAM directive
sed -i '/^UsePAM\s/d' /etc/ssh/sshd_config

# Add UsePAM directive
echo "UsePAM yes" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: UsePAM enabled"
