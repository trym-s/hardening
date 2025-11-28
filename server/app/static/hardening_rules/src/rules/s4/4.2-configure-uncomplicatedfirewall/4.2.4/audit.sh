#!/bin/bash
# 4.2.4 Ensure ufw loopback traffic is configured

if ufw status verbose | grep -q "Anywhere on lo" && \
   ufw status verbose | grep -q "ALLOW IN    Anywhere" && \
   ufw status verbose | grep -q "DENY IN     127.0.0.0/8"; then
    echo "Loopback traffic is configured"
    exit 0
else
    echo "Loopback traffic is not configured correctly"
    exit 1
fi
