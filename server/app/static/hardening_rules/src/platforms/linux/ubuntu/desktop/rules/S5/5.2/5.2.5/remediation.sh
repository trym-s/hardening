#!/bin/bash

# Remove !authenticate from sudoers
echo "Checking for !authenticate entries..."

noauth_files=$(grep -rPil -- '^\h*Defaults\h+([^#]+,\h*)?!authenticate' /etc/sudoers* 2>/dev/null)

if [ -z "$noauth_files" ]; then
    echo "INFO: No !authenticate entries found"
else
    echo "WARNING: !authenticate entries found in:"
    echo "$noauth_files"
    echo ""
    echo "MANUAL ACTION REQUIRED:"
    echo "Edit the above files and remove lines containing !authenticate"
    echo "Use 'visudo' or 'visudo -f <file>' to safely edit sudoers files"
    return 1
fi
