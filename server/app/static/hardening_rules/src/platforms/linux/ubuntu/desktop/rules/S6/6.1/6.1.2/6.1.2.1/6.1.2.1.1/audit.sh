#!/bin/bash

# 6.1.2.1.1 Ensure systemd-journal-remote is installed (Automated)

echo "Checking if systemd-journal-remote is installed..."

if dpkg-query -s systemd-journal-remote &>/dev/null; then
    version=$(dpkg-query -W -f='${Version}' systemd-journal-remote)
    echo "PASS: systemd-journal-remote is installed (version: $version)"
    exit 0
else
    echo "FAIL: systemd-journal-remote is not installed"
    exit 1
fi
