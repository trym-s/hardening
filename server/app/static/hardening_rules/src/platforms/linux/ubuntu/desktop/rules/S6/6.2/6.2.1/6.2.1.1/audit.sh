#!/bin/bash

# 6.2.1.1 Ensure auditd packages are installed (Automated)

echo "Checking if auditd packages are installed..."

packages="auditd audispd-plugins"
all_installed=true

for pkg in $packages; do
    if dpkg-query -s "$pkg" &>/dev/null; then
        version=$(dpkg-query -W -f='${Version}' "$pkg")
        echo "PASS: $pkg is installed (version: $version)"
    else
        echo "FAIL: $pkg is not installed"
        all_installed=false
    fi
done

if $all_installed; then
    exit 0
else
    exit 1
fi
