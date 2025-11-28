#!/bin/bash
# 4.2.1 Ensure ufw is installed

if dpkg-query -W -f='${Status}' ufw 2>/dev/null | grep -q "install ok installed"; then
    echo "ufw is installed"
    exit 0
else
    echo "ufw is not installed"
    exit 1
fi
