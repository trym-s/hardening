#!/bin/bash
# CIS Benchmark 2.1.5 - Ensure dnsmasq services are not in use
# Remediation Script

echo "Applying remediation for CIS 2.1.5..."

systemctl stop dnsmasq.service 2>/dev/null
systemctl mask dnsmasq.service 2>/dev/null

if dpkg-query -W -f='${db:Status-Status}' dnsmasq 2>/dev/null | grep -q "installed"; then
    apt purge -y dnsmasq
fi

echo "Remediation complete for CIS 2.1.5"
