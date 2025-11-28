#!/bin/bash
# 4.4.3.3 Ensure ip6tables outbound and established connections are configured

if ip6tables -L OUTPUT -v | grep -q "state NEW,ESTABLISHED" && \
   ip6tables -L INPUT -v | grep -q "state ESTABLISHED"; then
    echo "Outbound and established connections configured"
    exit 0
else
    echo "Outbound and established connections not configured"
    exit 1
fi
