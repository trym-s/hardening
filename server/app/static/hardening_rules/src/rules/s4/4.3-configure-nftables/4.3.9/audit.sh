#!/bin/bash
# 4.3.9 Ensure nftables service is enabled

if systemctl is-enabled nftables | grep -q "enabled"; then
    echo "nftables service is enabled"
    exit 0
else
    echo "nftables service is not enabled"
    exit 1
fi
