#!/bin/bash
# 4.4.1.2 Ensure nftables is not in use with iptables

if dpkg-query -W -f='${Status}' nftables 2>/dev/null | grep -q "install ok installed"; then
    if systemctl is-active nftables | grep -q "active"; then
        echo "nftables is active"
        exit 1
    fi
fi

echo "nftables is not in use"
exit 0
