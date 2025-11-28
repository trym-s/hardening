#!/bin/bash
if dpkg -s prelink >/dev/null 2>&1; then
    echo "prelink is installed"
    exit 1
else
    echo "prelink is NOT installed"
    exit 0
fi
