#!/bin/bash
# 4.4.3.1 Ensure ip6tables default deny firewall policy

if ip6tables -L INPUT | grep -q "Chain INPUT (policy DROP)" && \
   ip6tables -L FORWARD | grep -q "Chain FORWARD (policy DROP)" && \
   ip6tables -L OUTPUT | grep -q "Chain OUTPUT (policy DROP)"; then
    echo "Default deny policy configured"
    exit 0
else
    echo "Default deny policy not configured"
    exit 1
fi
