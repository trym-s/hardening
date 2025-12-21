#!/bin/bash

# Remove NOPASSWD entries from sudoers
echo "Checking for NOPASSWD entries..."

nopasswd_files=$(grep -rPil -- '^\h*([^#\n\r]+)?NOPASSWD' /etc/sudoers* 2>/dev/null)

if [ -z "$nopasswd_files" ]; then
    echo "INFO: No NOPASSWD entries found"
else
    echo "WARNING: NOPASSWD entries found in:"
    echo "$nopasswd_files"
    echo ""
    echo "MANUAL ACTION REQUIRED:"
    echo "Edit the above files and remove or comment out lines containing NOPASSWD"
    echo "Use 'visudo' or 'visudo -f <file>' to safely edit sudoers files"
    return 1
fi
