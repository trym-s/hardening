#!/bin/bash

# 6.1.3.6 Ensure rsyslog is configured to send logs to a remote log host (Manual)

echo "Checking if rsyslog is configured to send logs to a remote log host..."

# Check for remote host configuration
remote_config=$(grep -E '^\*\.\*[[:space:]]+@' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null)

echo "Remote host configurations found:"
echo "${remote_config:-None}"

if [ -n "$remote_config" ]; then
    echo "PASS: rsyslog is configured to send logs to a remote host"
    exit 0
else
    echo "FAIL: rsyslog is not configured to send logs to a remote host"
    exit 1
fi
