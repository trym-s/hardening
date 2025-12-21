#!/bin/bash
if mountpoint -q /home; then
    echo "/home is a separate partition"
    exit 0
else
    echo "/home is NOT a separate partition"
    exit 1
fi
