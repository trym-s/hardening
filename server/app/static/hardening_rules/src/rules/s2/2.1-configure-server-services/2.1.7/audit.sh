#!/bin/bash
if systemctl is-enabled slapd 2>/dev/null | grep -q 'enabled'; then
    echo "slapd is enabled"
    exit 1
else
    echo "slapd is disabled"
    exit 0
fi
