#!/bin/bash
# CIS 4.2.7 Ensure ufw default deny firewall policy

echo "Applying remediation for CIS 4.2.7..."

# Allow SSH first to prevent lockout
ufw allow 22/tcp comment "SSH - prevent lockout"

# Set default policies
ufw default deny incoming
ufw default allow outgoing
ufw default deny routed

echo "Remediation complete for CIS 4.2.7"
