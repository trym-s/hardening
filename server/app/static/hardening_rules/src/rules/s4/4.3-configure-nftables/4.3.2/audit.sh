#!/bin/bash
# 4.3.2 Ensure ufw is uninstalled or disabled with nftables

if dpkg-query -W -f='${Status}' ufw 2>/dev/null | grep -q "install ok installed"; then
    if ufw status | grep -q "Status: active"; then
        echo "ufw is installed and active"
        exit 1
    fi
fi

if dpkg-query -W -f='${Status}' iptables-persistent 2>/dev/null | grep -q "install ok installed"; then
    echo "iptables-persistent is installed"
    exit 1
fi

echo "ufw and iptables-persistent are not interfering"
exit 0
