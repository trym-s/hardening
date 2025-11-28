#!/bin/bash
# 4.3.6 Ensure nftables loopback traffic is configured

if nft list ruleset | grep -q 'iif "lo" accept' && \
   nft list ruleset | grep -q 'ip saddr 127.0.0.0/8 counter packets 0 bytes 0 drop' && \
   nft list ruleset | grep -q 'ip6 saddr ::1 counter packets 0 bytes 0 drop'; then
    echo "Loopback traffic configured"
    exit 0
else
    echo "Loopback traffic not configured correctly"
    exit 1
fi
