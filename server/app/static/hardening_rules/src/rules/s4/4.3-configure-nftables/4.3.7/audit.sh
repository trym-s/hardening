#!/bin/bash
# 4.3.7 Ensure nftables outbound and established connections are configured

if nft list ruleset | grep -q 'ip protocol tcp ct state established,related accept' && \
   nft list ruleset | grep -q 'ip protocol udp ct state established,related accept' && \
   nft list ruleset | grep -q 'ip protocol icmp ct state established,related accept'; then
    echo "Outbound and established connections configured"
    exit 0
else
    echo "Outbound and established connections not configured"
    exit 1
fi
