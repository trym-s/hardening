#!/bin/bash
# CIS Benchmark 2.1.2 - Ensure avahi daemon services are not in use
# Remediation Script

echo "Applying remediation for CIS 2.1.2..."

systemctl stop avahi-daemon.service 2>/dev/null
systemctl stop avahi-daemon.socket 2>/dev/null
systemctl mask avahi-daemon.service 2>/dev/null
systemctl mask avahi-daemon.socket 2>/dev/null

if dpkg-query -W -f='${db:Status-Status}' avahi-daemon 2>/dev/null | grep -q "installed"; then
    apt purge -y avahi-daemon
fi

echo "Remediation complete for CIS 2.1.2"
