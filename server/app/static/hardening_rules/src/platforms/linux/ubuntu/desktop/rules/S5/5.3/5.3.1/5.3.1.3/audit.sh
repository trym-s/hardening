#!/bin/bash

# Check if libpam-pwquality is installed
if dpkg-query -W libpam-pwquality &>/dev/null; then
    version=$(dpkg-query -W -f='${Version}' libpam-pwquality 2>/dev/null)
    echo "PASS: libpam-pwquality is installed (version: $version)"
    exit 0
else
    echo "FAIL: libpam-pwquality is not installed"
    exit 1
fi
