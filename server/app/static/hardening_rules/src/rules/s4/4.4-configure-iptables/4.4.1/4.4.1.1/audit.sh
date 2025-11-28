#!/bin/bash
# 4.4.1.1 Ensure iptables packages are installed

if dpkg-query -W -f='${Status}' iptables 2>/dev/null | grep -q "install ok installed" && \
   dpkg-query -W -f='${Status}' iptables-persistent 2>/dev/null | grep -q "install ok installed"; then
    echo "iptables packages are installed"
    exit 0
else
    echo "iptables packages are not installed"
    exit 1
fi
