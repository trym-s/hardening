#!/bin/bash
if dpkg -s sudo >/dev/null 2>&1; then
    echo "sudo is installed"
    exit 0
else
    echo "sudo is NOT installed"
    exit 1
fi
