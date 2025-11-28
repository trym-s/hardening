#!/bin/bash
if systemctl is-enabled vsftpd 2>/dev/null | grep -q 'enabled'; then
    echo "vsftpd is enabled"
    exit 1
else
    echo "vsftpd is disabled"
    exit 0
fi
