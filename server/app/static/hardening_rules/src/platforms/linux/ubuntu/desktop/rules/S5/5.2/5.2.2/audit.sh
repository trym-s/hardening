#!/bin/bash

# Check if sudo commands use pty
if grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,)?use_pty' /etc/sudoers* &>/dev/null; then
    echo "PASS: sudo is configured to use pty"
    grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,)?use_pty' /etc/sudoers*
    exit 0
else
    echo "FAIL: sudo is not configured to use pty"
    exit 1
fi
