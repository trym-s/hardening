#!/bin/bash

# Remediate sshd IgnoreRhosts configuration
echo "Enabling sshd IgnoreRhosts..."

# Remove any existing IgnoreRhosts directive
sed -i '/^IgnoreRhosts\s/d' /etc/ssh/sshd_config

# Add IgnoreRhosts directive
echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: IgnoreRhosts enabled"
