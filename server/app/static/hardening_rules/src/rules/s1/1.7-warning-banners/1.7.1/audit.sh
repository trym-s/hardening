#!/bin/bash
if grep -q "Authorized users only" /etc/motd; then
    echo "motd is configured"
    exit 0
else
    echo "motd is NOT configured"
    exit 1
fi
