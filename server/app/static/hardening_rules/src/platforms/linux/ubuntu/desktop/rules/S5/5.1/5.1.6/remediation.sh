#!/bin/bash

# Remediate sshd Ciphers configuration
echo "Configuring sshd Ciphers..."

# Remove any existing Ciphers directive
sed -i '/^Ciphers\s/d' /etc/ssh/sshd_config

# Add strong Ciphers directive
echo "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: Strong ciphers configured"
