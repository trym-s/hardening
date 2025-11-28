#!/bin/bash
if systemctl is-enabled cups 2>/dev/null | grep -q 'enabled'; then
    echo "cups is enabled"
    exit 1
else
    echo "cups is disabled"
    exit 0
fi
