#!/bin/bash
# 3.3.4 Ensure broadcast icmp requests are ignored

if sysctl net.ipv4.icmp_echo_ignore_broadcasts | grep -q "1"; then
    echo "Broadcast ICMP requests are ignored"
    exit 0
else
    echo "Broadcast ICMP requests are not ignored"
    exit 1
fi
