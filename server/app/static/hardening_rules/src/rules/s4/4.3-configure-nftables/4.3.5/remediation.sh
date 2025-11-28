#!/bin/bash
# 4.3.5 Ensure nftables base chains exist

nft add chain inet filter input '{ type filter hook input priority 0; }'
nft add chain inet filter forward '{ type filter hook forward priority 0; }'
nft add chain inet filter output '{ type filter hook output priority 0; }'
