#!/bin/bash
# 4.3.10 Ensure nftables rules are permanent

if grep -q "include \"/etc/nftables.conf\"" /etc/sysconfig/nftables.conf 2>/dev/null || \
   [ -f /etc/nftables.conf ]; then
    echo "nftables rules are permanent"
    exit 0
else
    echo "nftables rules are not permanent"
    exit 1
fi
