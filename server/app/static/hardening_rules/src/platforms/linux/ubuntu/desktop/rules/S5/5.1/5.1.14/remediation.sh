#!/bin/bash

# Remediate sshd LogLevel configuration
echo "Configuring sshd LogLevel..."

# Remove any existing LogLevel directive
sed -i '/^LogLevel\s/d' /etc/ssh/sshd_config

# Add LogLevel directive
echo "LogLevel VERBOSE" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: LogLevel set to VERBOSE"
