#!/bin/bash
# 3.1.3 Ensure bluetooth services are not in use

if systemctl is-active bluetooth >/dev/null 2>&1; then
    echo "Bluetooth service is active"
    exit 1
fi

echo "Bluetooth service is not active"
exit 0
