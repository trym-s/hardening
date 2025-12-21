#!/bin/bash

# Remediate sshd KexAlgorithms configuration
echo "Configuring sshd KexAlgorithms..."

# Remove any existing KexAlgorithms directive
sed -i '/^KexAlgorithms\s/d' /etc/ssh/sshd_config

# Add strong KexAlgorithms directive
echo "KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: Strong key exchange algorithms configured"
