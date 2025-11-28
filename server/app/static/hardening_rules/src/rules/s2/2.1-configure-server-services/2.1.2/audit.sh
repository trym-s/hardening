#!/bin/bash
if systemctl is-enabled avahi-daemon 2>/dev/null | grep -q 'enabled'; then
    echo "avahi-daemon is enabled"
    exit 1
else
    echo "avahi-daemon is disabled"
    exit 0
fi
