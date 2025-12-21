#!/bin/bash

# 6.1.3.3 Ensure journald is configured to send logs to rsyslog (Automated)

echo "Checking if journald is configured to send logs to rsyslog..."

# Check ForwardToSyslog setting
forward=$(grep -E "^ForwardToSyslog=" /etc/systemd/journald.conf 2>/dev/null)

echo "ForwardToSyslog: ${forward:-Not configured}"

if echo "$forward" | grep -qi "yes"; then
    echo "PASS: journald is configured to send logs to rsyslog"
    exit 0
else
    echo "FAIL: journald is not configured to send logs to rsyslog"
    exit 1
fi
