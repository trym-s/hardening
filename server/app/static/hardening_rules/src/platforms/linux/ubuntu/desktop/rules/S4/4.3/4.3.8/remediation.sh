#!/bin/bash
# CIS 4.3.8 Ensure nftables default deny firewall policy

echo "Applying remediation for CIS 4.3.8..."
echo "WARNING: Setting default deny - ensure SSH is allowed first!"

# Allow SSH to prevent lockout
nft add rule inet filter input tcp dport 22 accept 2>/dev/null

# Set default policies to drop
nft 'chain inet filter input { policy drop; }' 2>/dev/null
nft 'chain inet filter forward { policy drop; }' 2>/dev/null
# Note: Output policy often left as accept
nft 'chain inet filter output { policy accept; }' 2>/dev/null

echo "Remediation complete for CIS 4.3.8"
