#!/bin/bash
# 4.4.2.3 Ensure iptables outbound and established connections are configured

if iptables -L OUTPUT -v | grep -q "state NEW,ESTABLISHED" && \
   iptables -L INPUT -v | grep -q "state ESTABLISHED"; then
    echo "Outbound and established connections configured"
    exit 0
else
    echo "Outbound and established connections not configured"
    exit 1
fi
