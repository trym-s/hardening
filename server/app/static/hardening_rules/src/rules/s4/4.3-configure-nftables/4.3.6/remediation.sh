#!/bin/bash
# 4.3.6 Ensure nftables loopback traffic is configured

nft add rule inet filter input iif "lo" accept
nft add rule inet filter input ip saddr 127.0.0.0/8 counter drop
nft add rule inet filter input ip6 saddr ::1 counter drop
