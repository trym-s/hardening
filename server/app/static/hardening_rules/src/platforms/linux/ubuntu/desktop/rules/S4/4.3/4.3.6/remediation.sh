#!/bin/bash
# CIS 4.3.6 Ensure nftables loopback traffic is configured

echo "Applying remediation for CIS 4.3.6..."

nft add rule inet filter input iif lo accept 2>/dev/null
nft add rule inet filter input ip saddr 127.0.0.0/8 counter drop 2>/dev/null

echo "Remediation complete for CIS 4.3.6"
