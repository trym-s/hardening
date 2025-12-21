#!/bin/bash

# 7.1.11 Ensure world writable files and directories are secured (Automated)

echo "Checking for world writable files and directories..."

# Find world writable files (excluding /proc, /sys, /dev, /run)
world_writable=$(find / -xdev -type f -perm -0002 ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" ! -path "/run/*" 2>/dev/null)

# Find world writable directories without sticky bit
world_writable_dirs=$(find / -xdev -type d -perm -0002 ! -perm -1000 ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" ! -path "/run/*" 2>/dev/null)

if [ -z "$world_writable" ] && [ -z "$world_writable_dirs" ]; then
    echo "PASS: No insecure world writable files or directories found"
    exit 0
else
    echo "FAIL: Found world writable files or directories without proper protection:"
    if [ -n "$world_writable" ]; then
        echo "World writable files:"
        echo "$world_writable"
    fi
    if [ -n "$world_writable_dirs" ]; then
        echo "World writable directories without sticky bit:"
        echo "$world_writable_dirs"
    fi
    exit 1
fi
