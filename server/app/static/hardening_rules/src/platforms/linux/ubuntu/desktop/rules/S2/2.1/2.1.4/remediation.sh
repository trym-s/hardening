#!/bin/bash
# CIS Benchmark 2.1.4 - Ensure dns server services are not in use
# Remediation Script

echo "Applying remediation for CIS 2.1.4..."

systemctl stop named.service 2>/dev/null
systemctl mask named.service 2>/dev/null

if dpkg-query -W -f='${db:Status-Status}' bind9 2>/dev/null | grep -q "installed"; then
    apt purge -y bind9
fi

echo "Remediation complete for CIS 2.1.4"
