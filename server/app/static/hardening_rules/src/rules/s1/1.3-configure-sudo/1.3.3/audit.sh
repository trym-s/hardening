#!/bin/bash
if grep -q "^Defaults.*logfile=" /etc/sudoers; then
    echo "logfile is configured"
    exit 0
else
    echo "logfile is NOT configured"
    exit 1
fi
