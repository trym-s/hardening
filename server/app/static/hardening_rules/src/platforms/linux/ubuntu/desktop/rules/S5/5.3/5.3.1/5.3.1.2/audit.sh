#!/bin/bash

# Check if libpam-modules is installed
if dpkg-query -W libpam-modules &>/dev/null; then
    version=$(dpkg-query -W -f='${Version}' libpam-modules 2>/dev/null)
    echo "PASS: libpam-modules is installed (version: $version)"
    exit 0
else
    echo "FAIL: libpam-modules is not installed"
    exit 1
fi
