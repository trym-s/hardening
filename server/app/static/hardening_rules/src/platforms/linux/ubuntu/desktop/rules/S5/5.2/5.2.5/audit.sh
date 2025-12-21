#!/bin/bash

# Check if re-authentication is disabled globally
noauth=$(grep -rPi -- '^\h*Defaults\h+([^#]+,\h*)?!authenticate' /etc/sudoers* 2>/dev/null)

if [ -z "$noauth" ]; then
    echo "PASS: Re-authentication is not disabled globally"
    exit 0
else
    echo "FAIL: Re-authentication is disabled globally"
    echo "$noauth"
    exit 1
fi
