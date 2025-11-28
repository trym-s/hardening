#!/bin/bash
if systemctl is-enabled isc-dhcp-server 2>/dev/null | grep -q 'enabled'; then
    echo "isc-dhcp-server is enabled"
    exit 1
else
    echo "isc-dhcp-server is disabled"
    exit 0
fi
