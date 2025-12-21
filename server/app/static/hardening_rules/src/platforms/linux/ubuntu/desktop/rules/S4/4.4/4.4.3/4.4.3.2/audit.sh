#!/bin/bash
# 4.4.3.2 Ensure ip6tables loopback traffic is configured

if ip6tables -L INPUT -v | grep -q "lo" && \
   ip6tables -L OUTPUT -v | grep -q "lo" && \
   ip6tables -L INPUT -v | grep -q "::1"; then
    echo "Loopback traffic configured"
    exit 0
else
    echo "Loopback traffic not configured correctly"
    exit 1
fi
