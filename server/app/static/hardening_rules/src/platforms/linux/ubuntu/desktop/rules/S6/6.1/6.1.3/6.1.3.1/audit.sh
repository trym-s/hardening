#!/bin/bash

# 6.1.3.1 Ensure rsyslog is installed (Automated)

echo "Checking if rsyslog is installed..."

if dpkg-query -s rsyslog &>/dev/null; then
    version=$(dpkg-query -W -f='${Version}' rsyslog)
    echo "PASS: rsyslog is installed (version: $version)"
    exit 0
else
    echo "FAIL: rsyslog is not installed"
    exit 1
fi
