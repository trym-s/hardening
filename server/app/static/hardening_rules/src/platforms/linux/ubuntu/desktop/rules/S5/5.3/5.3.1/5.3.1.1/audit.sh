#!/bin/bash

# Check if latest pam is installed
if dpkg-query -W libpam-runtime &>/dev/null; then
    version=$(dpkg-query -W -f='${Version}' libpam-runtime 2>/dev/null)
    echo "PASS: libpam-runtime is installed (version: $version)"
    exit 0
else
    echo "FAIL: libpam-runtime is not installed"
    exit 1
fi
