#!/bin/bash

# 6.1.2.2 Ensure journald ForwardToSyslog is disabled (Automated)

echo "Checking journald ForwardToSyslog configuration..."

# Check ForwardToSyslog setting
forward=$(grep -E "^ForwardToSyslog=" /etc/systemd/journald.conf 2>/dev/null)

echo "ForwardToSyslog: ${forward:-Not configured (default: no)}"

if [ -z "$forward" ] || echo "$forward" | grep -qi "no"; then
    echo "PASS: ForwardToSyslog is disabled or not configured (default is no)"
    exit 0
else
    echo "FAIL: ForwardToSyslog is enabled"
    exit 1
fi
