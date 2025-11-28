#!/bin/bash
# 4.3.7 Ensure nftables outbound and established connections are configured

nft add rule inet filter input ip protocol tcp ct state established,related accept
nft add rule inet filter input ip protocol udp ct state established,related accept
nft add rule inet filter input ip protocol icmp ct state established,related accept
nft add rule inet filter output ip protocol tcp ct state new,established,related accept
nft add rule inet filter output ip protocol udp ct state new,established,related accept
nft add rule inet filter output ip protocol icmp ct state new,established,related accept
