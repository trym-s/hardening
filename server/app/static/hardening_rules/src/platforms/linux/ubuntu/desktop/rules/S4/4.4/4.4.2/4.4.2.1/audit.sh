#!/bin/bash
# 4.4.2.1 Ensure iptables default deny firewall policy

if iptables -L INPUT | grep -q "Chain INPUT (policy DROP)" && \
   iptables -L FORWARD | grep -q "Chain FORWARD (policy DROP)" && \
   iptables -L OUTPUT | grep -q "Chain OUTPUT (policy DROP)"; then
    echo "Default deny policy configured"
    exit 0
else
    echo "Default deny policy not configured"
    exit 1
fi
