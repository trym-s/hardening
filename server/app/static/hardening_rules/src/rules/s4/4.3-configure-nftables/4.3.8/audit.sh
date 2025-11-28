#!/bin/bash
# 4.3.8 Ensure nftables default deny firewall policy

if nft list chain inet filter input | grep -q "policy drop" && \
   nft list chain inet filter forward | grep -q "policy drop" && \
   nft list chain inet filter output | grep -q "policy drop"; then
    echo "Default deny policy configured"
    exit 0
else
    echo "Default deny policy not configured"
    exit 1
fi
