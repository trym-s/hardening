#!/bin/bash

# Remediate sshd LoginGraceTime configuration
echo "Configuring sshd LoginGraceTime..."

# Remove any existing LoginGraceTime directive
sed -i '/^LoginGraceTime\s/d' /etc/ssh/sshd_config

# Add LoginGraceTime directive
echo "LoginGraceTime 60" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: LoginGraceTime set to 60 seconds"
