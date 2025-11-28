#!/bin/bash
if dpkg -s apparmor >/dev/null 2>&1 && dpkg -s apparmor-utils >/dev/null 2>&1; then
    echo "AppArmor is installed"
    exit 0
else
    echo "AppArmor is NOT installed"
    exit 1
fi
