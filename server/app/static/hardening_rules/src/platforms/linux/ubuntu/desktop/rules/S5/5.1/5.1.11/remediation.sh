#!/bin/bash

# Remediate sshd KerberosAuthentication configuration
echo "Disabling sshd KerberosAuthentication..."

# Remove any existing KerberosAuthentication directive
sed -i '/^KerberosAuthentication\s/d' /etc/ssh/sshd_config

# Add KerberosAuthentication directive
echo "KerberosAuthentication no" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: KerberosAuthentication disabled"
