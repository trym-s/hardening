#!/bin/bash

# Remediate sshd MaxSessions configuration
echo "Configuring sshd MaxSessions..."

# Remove any existing MaxSessions directive
sed -i '/^MaxSessions\s/d' /etc/ssh/sshd_config

# Add MaxSessions directive
echo "MaxSessions 10" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: MaxSessions set to 10"
