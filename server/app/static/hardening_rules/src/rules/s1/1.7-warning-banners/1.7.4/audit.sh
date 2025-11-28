#!/bin/bash
if [ "$(stat -c "%a %u %g" /etc/motd)" == "644 0 0" ]; then
    echo "Permissions on /etc/motd are correct"
    exit 0
else
    echo "Permissions on /etc/motd are INCORRECT"
    exit 1
fi
