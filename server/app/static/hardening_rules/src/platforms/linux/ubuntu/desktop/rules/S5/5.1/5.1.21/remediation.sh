#!/bin/bash

# Remediate sshd PermitUserEnvironment configuration
echo "Disabling sshd PermitUserEnvironment..."

# Remove any existing PermitUserEnvironment directive
sed -i '/^PermitUserEnvironment\s/d' /etc/ssh/sshd_config

# Add PermitUserEnvironment directive
echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: PermitUserEnvironment disabled"
