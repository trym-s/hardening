#!/bin/bash

# Remediate sshd PermitEmptyPasswords configuration
echo "Disabling sshd PermitEmptyPasswords..."

# Remove any existing PermitEmptyPasswords directive
sed -i '/^PermitEmptyPasswords\s/d' /etc/ssh/sshd_config

# Add PermitEmptyPasswords directive
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: PermitEmptyPasswords disabled"
