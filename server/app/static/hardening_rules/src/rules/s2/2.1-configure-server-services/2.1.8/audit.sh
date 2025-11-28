#!/bin/bash
if systemctl is-enabled dovecot 2>/dev/null | grep -q 'enabled'; then
    echo "dovecot is enabled"
    exit 1
else
    echo "dovecot is disabled"
    exit 0
fi
