#!/bin/bash
if systemctl is-enabled dnsmasq 2>/dev/null | grep -q 'enabled'; then
    echo "dnsmasq is enabled"
    exit 1
else
    echo "dnsmasq is disabled"
    exit 0
fi
