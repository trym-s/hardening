#!/bin/bash
# 3.3.6 Ensure secure icmp redirects are not accepted

if sysctl net.ipv4.conf.all.secure_redirects | grep -q "0" && \
   sysctl net.ipv4.conf.default.secure_redirects | grep -q "0"; then
    echo "Secure ICMP redirects are not accepted"
    exit 0
else
    echo "Secure ICMP redirects are accepted"
    exit 1
fi
