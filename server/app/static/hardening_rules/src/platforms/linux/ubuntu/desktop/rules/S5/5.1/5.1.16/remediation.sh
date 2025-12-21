#!/bin/bash

# Remediate sshd MaxAuthTries configuration
echo "Configuring sshd MaxAuthTries..."

# Remove any existing MaxAuthTries directive
sed -i '/^MaxAuthTries\s/d' /etc/ssh/sshd_config

# Add MaxAuthTries directive
echo "MaxAuthTries 4" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: MaxAuthTries set to 4"
