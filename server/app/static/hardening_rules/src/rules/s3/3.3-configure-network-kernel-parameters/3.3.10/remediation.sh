#!/bin/bash
# 3.3.10 Ensure tcp syn cookies is enabled

sysctl -w net.ipv4.tcp_syncookies=1

if grep -q "^net.ipv4.tcp_syncookies" /etc/sysctl.conf; then
    sed -i 's/^net.ipv4.tcp_syncookies.*/net.ipv4.tcp_syncookies = 1/' /etc/sysctl.conf
else
    echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
fi
