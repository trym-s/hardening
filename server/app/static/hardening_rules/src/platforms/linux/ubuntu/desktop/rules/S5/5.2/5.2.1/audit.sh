#!/bin/bash

# Check if sudo is installed
if dpkg-query -W sudo &>/dev/null; then
    version=$(dpkg-query -W -f='${Version}' sudo 2>/dev/null)
    echo "PASS: sudo is installed (version: $version)"
    exit 0
else
    echo "FAIL: sudo is not installed"
    exit 1
fi
