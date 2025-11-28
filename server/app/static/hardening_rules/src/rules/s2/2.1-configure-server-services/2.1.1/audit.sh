#!/bin/bash
if systemctl is-enabled autofs 2>/dev/null | grep -q 'enabled'; then
    echo "autofs is enabled"
    exit 1
else
    echo "autofs is disabled"
    exit 0
fi
