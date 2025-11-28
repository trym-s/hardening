#!/bin/bash
if systemctl is-enabled bind9 2>/dev/null | grep -q 'enabled'; then
    echo "bind9 is enabled"
    exit 1
else
    echo "bind9 is disabled"
    exit 0
fi
