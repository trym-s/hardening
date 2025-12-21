#!/bin/bash
if mountpoint -q /var/log; then
    echo "/var/log is a separate partition"
    exit 0
else
    echo "/var/log is NOT a separate partition"
    exit 1
fi
