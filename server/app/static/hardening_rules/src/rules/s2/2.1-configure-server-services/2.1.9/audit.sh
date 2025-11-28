#!/bin/bash
if systemctl is-enabled nfs-server 2>/dev/null | grep -q 'enabled'; then
    echo "nfs-server is enabled"
    exit 1
else
    echo "nfs-server is disabled"
    exit 0
fi
