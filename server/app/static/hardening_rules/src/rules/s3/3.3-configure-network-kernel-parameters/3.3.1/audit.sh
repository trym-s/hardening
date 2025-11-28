#!/bin/bash
# 3.3.1 Ensure ip forwarding is disabled

if sysctl net.ipv4.ip_forward | grep -q "0"; then
    echo "net.ipv4.ip_forward is correctly set to 0"
    exit 0
else
    echo "net.ipv4.ip_forward is not set to 0"
    exit 1
fi
