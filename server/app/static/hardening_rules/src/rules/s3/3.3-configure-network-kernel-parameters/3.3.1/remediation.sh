#!/bin/bash
# 3.3.1 Ensure ip forwarding is disabled

sysctl -w net.ipv4.ip_forward=0

if grep -q "^net.ipv4.ip_forward" /etc/sysctl.conf; then
    sed -i 's/^net.ipv4.ip_forward.*/net.ipv4.ip_forward = 0/' /etc/sysctl.conf
else
    echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf
fi
