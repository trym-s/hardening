#!/bin/bash
if mountpoint -q /var/log/audit; then
    echo "/var/log/audit is a separate partition"
    exit 0
else
    echo "/var/log/audit is NOT a separate partition"
    exit 1
fi
