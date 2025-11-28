#!/bin/bash
# 4.2.2 Ensure iptables-persistent is not installed with ufw

if dpkg-query -W -f='${Status}' iptables-persistent 2>/dev/null | grep -q "install ok installed"; then
    echo "iptables-persistent is installed"
    exit 1
else
    echo "iptables-persistent is not installed"
    exit 0
fi
