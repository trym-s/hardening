#!/bin/bash

# 6.1.1.4 Ensure only one logging system is in use (Automated)

echo "Checking if only one logging system is active..."

# Check if rsyslog is active
rsyslog_active=$(systemctl is-active rsyslog 2>/dev/null)
# Check if journald is active
journald_active=$(systemctl is-active systemd-journald 2>/dev/null)

echo "rsyslog status: ${rsyslog_active:-not installed}"
echo "systemd-journald status: ${journald_active:-not installed}"

# If journald is configured to forward to syslog, both can coexist
forward_to_syslog=$(grep -E "^ForwardToSyslog=" /etc/systemd/journald.conf 2>/dev/null | grep -i "yes")

if [ "$journald_active" = "active" ]; then
    if [ "$rsyslog_active" = "active" ] && [ -z "$forward_to_syslog" ]; then
        echo "WARNING: Both journald and rsyslog are active without ForwardToSyslog"
        echo "This may result in duplicate logging"
        exit 1
    else
        echo "PASS: Logging system configuration is appropriate"
        exit 0
    fi
else
    echo "FAIL: systemd-journald is not active"
    exit 1
fi
