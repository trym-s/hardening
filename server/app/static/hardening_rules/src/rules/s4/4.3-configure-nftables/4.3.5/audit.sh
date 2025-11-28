#!/bin/bash
# 4.3.5 Ensure nftables base chains exist

if nft list chains inet filter | grep -q "hook input" && \
   nft list chains inet filter | grep -q "hook forward" && \
   nft list chains inet filter | grep -q "hook output"; then
    echo "Base chains exist"
    exit 0
else
    echo "Base chains missing"
    exit 1
fi
