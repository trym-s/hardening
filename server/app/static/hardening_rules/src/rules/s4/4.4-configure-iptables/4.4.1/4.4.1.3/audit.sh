#!/bin/bash
# 4.4.1.3 Ensure ufw is not in use with iptables

if dpkg-query -W -f='${Status}' ufw 2>/dev/null | grep -q "install ok installed"; then
    if ufw status | grep -q "Status: active"; then
        echo "ufw is active"
        exit 1
    fi
fi

echo "ufw is not in use"
exit 0
