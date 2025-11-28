#!/bin/bash
# 3.1.2 Ensure wireless interfaces are disabled

if command -v nmcli >/dev/null 2>&1; then
    if nmcli radio all | grep -q "enabled"; then
        echo "Wireless interfaces are enabled"
        exit 1
    fi
elif [ -n "$(find /sys/class/net/*/wireless 2>/dev/null)" ]; then
    echo "Wireless interfaces found"
    exit 1
fi

echo "Wireless interfaces are disabled or not present"
exit 0
