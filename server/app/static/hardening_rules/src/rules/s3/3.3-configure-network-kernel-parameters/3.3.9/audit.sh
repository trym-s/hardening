#!/bin/bash
# 3.3.9 Ensure suspicious packets are logged

if sysctl net.ipv4.conf.all.log_martians | grep -q "1" && \
   sysctl net.ipv4.conf.default.log_martians | grep -q "1"; then
    echo "Suspicious packets are logged"
    exit 0
else
    echo "Suspicious packets are not logged"
    exit 1
fi
