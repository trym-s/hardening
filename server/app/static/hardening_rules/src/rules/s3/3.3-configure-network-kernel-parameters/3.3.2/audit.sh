#!/bin/bash
# 3.3.2 Ensure packet redirect sending is disabled

if sysctl net.ipv4.conf.all.send_redirects | grep -q "0" && \
   sysctl net.ipv4.conf.default.send_redirects | grep -q "0"; then
    echo "Packet redirect sending is disabled"
    exit 0
else
    echo "Packet redirect sending is enabled"
    exit 1
fi
