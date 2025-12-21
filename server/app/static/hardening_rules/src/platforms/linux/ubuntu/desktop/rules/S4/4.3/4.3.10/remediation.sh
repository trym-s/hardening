#!/bin/bash
# CIS 4.3.10 Ensure nftables rules are permanent

echo "Applying remediation for CIS 4.3.10..."

# Backup existing config if present
if [ -f /etc/nftables.conf ]; then
    cp /etc/nftables.conf /etc/nftables.conf.bak
fi

# Save current ruleset
nft list ruleset > /etc/nftables.conf

echo "Saved current ruleset to /etc/nftables.conf"
echo "Remediation complete for CIS 4.3.10"
