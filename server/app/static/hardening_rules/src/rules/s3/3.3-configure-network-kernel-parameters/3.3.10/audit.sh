#!/bin/bash
# 3.3.10 Ensure tcp syn cookies is enabled

if sysctl net.ipv4.tcp_syncookies | grep -q "1"; then
    echo "TCP SYN cookies are enabled"
    exit 0
else
    echo "TCP SYN cookies are disabled"
    exit 1
fi
