#!/bin/bash
# 3.1.2 Ensure wireless interfaces are disabled

if command -v nmcli >/dev/null 2>&1; then
    nmcli radio all off
else
    echo "nmcli not found, cannot disable wireless interfaces automatically"
    exit 1
fi
