#!/bin/bash
echo "Checking if AIDE is installed..."
if dpkg-query -s aide aide-common &>/dev/null; then
    echo "PASS: AIDE is installed"
    dpkg-query -W aide aide-common
    exit 0
else
    echo "FAIL: AIDE is not installed"
    exit 1
fi
