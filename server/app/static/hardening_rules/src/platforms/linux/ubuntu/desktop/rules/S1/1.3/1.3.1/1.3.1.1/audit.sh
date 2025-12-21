#!/bin/bash
if dpkg-query -s apparmor &>/dev/null; then
    if dpkg-query -s apparmor-utils &>/dev/null; then
        echo "apparmor and apparmor-utils are installed"
        exit 0  # Her ikisi de kurulu - BAŞARILI
    else
        echo "apparmor is installed but apparmor-utils is NOT installed"
        exit 1  # apparmor-utils eksik - BAŞARISIZ
    fi
else
    echo "apparmor is NOT installed"
    exit 1  # apparmor eksik - BAŞARISIZ
fi