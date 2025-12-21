#!/bin/bash

# Remediate sshd MACs configuration
echo "Configuring sshd MACs..."

# Remove any existing MACs directive
sed -i '/^MACs\s/d' /etc/ssh/sshd_config

# Add strong MACs directive
echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: Strong MACs configured"
