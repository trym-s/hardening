#!/bin/bash
# 4.2.3 Ensure ufw service is enabled

if systemctl is-enabled ufw | grep -q "enabled" && ufw status | grep -q "Status: active"; then
    echo "ufw service is enabled and active"
    exit 0
else
    echo "ufw service is not enabled or not active"
    exit 1
fi
