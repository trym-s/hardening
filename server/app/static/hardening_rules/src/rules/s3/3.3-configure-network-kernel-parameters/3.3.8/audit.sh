#!/bin/bash
# 3.3.8 Ensure source routed packets are not accepted

if sysctl net.ipv4.conf.all.accept_source_route | grep -q "0" && \
   sysctl net.ipv4.conf.default.accept_source_route | grep -q "0"; then
    echo "Source routed packets are not accepted"
    exit 0
else
    echo "Source routed packets are accepted"
    exit 1
fi
