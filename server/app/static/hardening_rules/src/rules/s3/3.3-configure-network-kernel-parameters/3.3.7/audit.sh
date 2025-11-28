#!/bin/bash
# 3.3.7 Ensure reverse path filtering is enabled

if sysctl net.ipv4.conf.all.rp_filter | grep -q "1" && \
   sysctl net.ipv4.conf.default.rp_filter | grep -q "1"; then
    echo "Reverse path filtering is enabled"
    exit 0
else
    echo "Reverse path filtering is disabled"
    exit 1
fi
