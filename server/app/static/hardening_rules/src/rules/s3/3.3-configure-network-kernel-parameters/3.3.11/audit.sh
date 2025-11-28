#!/bin/bash
# 3.3.11 Ensure ipv6 router advertisements are not accepted

if sysctl net.ipv6.conf.all.accept_ra | grep -q "0" && \
   sysctl net.ipv6.conf.default.accept_ra | grep -q "0"; then
    echo "IPv6 router advertisements are not accepted"
    exit 0
else
    echo "IPv6 router advertisements are accepted"
    exit 1
fi
