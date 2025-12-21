#!/bin/bash
# CIS Benchmark 2.1.3 - Ensure dhcp server services are not in use
# Remediation Script

echo "Applying remediation for CIS 2.1.3..."

systemctl stop isc-dhcp-server.service isc-dhcp-server6.service 2>/dev/null
systemctl mask isc-dhcp-server.service isc-dhcp-server6.service 2>/dev/null

if dpkg-query -W -f='${db:Status-Status}' isc-dhcp-server 2>/dev/null | grep -q "installed"; then
    apt purge -y isc-dhcp-server
fi

echo "Remediation complete for CIS 2.1.3"
