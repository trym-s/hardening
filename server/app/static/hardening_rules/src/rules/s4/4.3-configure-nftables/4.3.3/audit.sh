#!/bin/bash
# 4.3.3 Ensure iptables are flushed with nftables

if iptables -L | grep -q "Chain" && [ "$(iptables -L | wc -l)" -gt 8 ]; then
    echo "iptables rules exist"
    exit 1
fi

if ip6tables -L | grep -q "Chain" && [ "$(ip6tables -L | wc -l)" -gt 8 ]; then
    echo "ip6tables rules exist"
    exit 1
fi

echo "iptables are flushed"
exit 0
