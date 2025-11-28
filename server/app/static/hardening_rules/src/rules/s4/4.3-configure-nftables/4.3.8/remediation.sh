#!/bin/bash
# 4.3.8 Ensure nftables default deny firewall policy

nft chain inet filter input { policy drop \; }
nft chain inet filter forward { policy drop \; }
nft chain inet filter output { policy drop \; }
