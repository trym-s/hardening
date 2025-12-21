#!/bin/bash
# 4.4.2.2 Ensure iptables loopback traffic is configured

if iptables -L INPUT -v | grep -q "lo" && \
   iptables -L OUTPUT -v | grep -q "lo" && \
   iptables -L INPUT -v | grep -q "127.0.0.0/8"; then
    echo "Loopback traffic configured"
    exit 0
else
    echo "Loopback traffic not configured correctly"
    exit 1
fi
