#!/bin/bash

# Remediate sshd MaxStartups configuration
echo "Configuring sshd MaxStartups..."

# Remove any existing MaxStartups directive
sed -i '/^MaxStartups\s/d' /etc/ssh/sshd_config

# Add MaxStartups directive
echo "MaxStartups 10:30:60" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: MaxStartups set to 10:30:60"
