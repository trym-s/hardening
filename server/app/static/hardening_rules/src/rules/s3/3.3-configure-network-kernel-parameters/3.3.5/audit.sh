#!/bin/bash
# 3.3.5 Ensure icmp redirects are not accepted

if sysctl net.ipv4.conf.all.accept_redirects | grep -q "0" && \
   sysctl net.ipv4.conf.default.accept_redirects | grep -q "0"; then
    echo "ICMP redirects are not accepted"
    exit 0
else
    echo "ICMP redirects are accepted"
    exit 1
fi
