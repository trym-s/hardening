#!/bin/bash

# Check if sudo log file is configured
if grep -rPsi -- '^\h*Defaults\h+([^#]+,\h*)?logfile\h*=' /etc/sudoers* &>/dev/null; then
    echo "PASS: sudo log file is configured"
    grep -rPsi -- '^\h*Defaults\h+([^#]+,\h*)?logfile\h*=' /etc/sudoers*
    exit 0
else
    echo "FAIL: sudo log file is not configured"
    exit 1
fi
