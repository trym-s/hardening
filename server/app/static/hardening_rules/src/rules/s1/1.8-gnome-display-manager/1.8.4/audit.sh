#!/bin/bash
if grep -q "Enable=false" /etc/gdm3/custom.conf; then
    echo "XDMCP is disabled"
    exit 0
else
    echo "XDMCP is NOT disabled"
    exit 1
fi
