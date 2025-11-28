#!/bin/bash
if mountpoint -q /var/tmp; then
    echo "/var/tmp is a separate partition"
    exit 0
else
    echo "/var/tmp is NOT a separate partition"
    exit 1
fi
