#!/bin/bash
if mountpoint -q /var; then
    echo "/var is a separate partition"
    exit 0
else
    echo "/var is NOT a separate partition"
    exit 1
fi
