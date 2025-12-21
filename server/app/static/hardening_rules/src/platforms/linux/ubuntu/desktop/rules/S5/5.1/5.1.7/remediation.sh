#!/bin/bash

# Remediate sshd DisableForwarding configuration
echo "Enabling sshd DisableForwarding..."

# Remove any existing DisableForwarding directive
sed -i '/^DisableForwarding\s/d' /etc/ssh/sshd_config

# Add DisableForwarding directive
echo "DisableForwarding yes" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: DisableForwarding enabled"
