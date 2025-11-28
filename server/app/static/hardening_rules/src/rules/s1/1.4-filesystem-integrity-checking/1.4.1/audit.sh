#!/bin/bash
if dpkg -s aide >/dev/null 2>&1; then
    echo "aide is installed"
    exit 0
else
    echo "aide is NOT installed"
    exit 1
fi
