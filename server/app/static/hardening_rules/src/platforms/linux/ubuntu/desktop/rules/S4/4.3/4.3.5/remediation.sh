#!/bin/bash
# CIS 4.3.5 Ensure nftables base chains exist

echo "Applying remediation for CIS 4.3.5..."

# Create table if not exists
nft create table inet filter 2>/dev/null

# Create base chains
nft 'create chain inet filter input { type filter hook input priority 0; }' 2>/dev/null
nft 'create chain inet filter forward { type filter hook forward priority 0; }' 2>/dev/null
nft 'create chain inet filter output { type filter hook output priority 0; }' 2>/dev/null

echo "Base chains created"
echo "Remediation complete for CIS 4.3.5"
