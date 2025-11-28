#!/bin/bash
# 4.3.1 Ensure nftables is installed

if dpkg-query -W -f='${Status}' nftables 2>/dev/null | grep -q "install ok installed"; then
    echo "nftables is installed"
    exit 0
else
    echo "nftables is not installed"
    exit 1
fi
