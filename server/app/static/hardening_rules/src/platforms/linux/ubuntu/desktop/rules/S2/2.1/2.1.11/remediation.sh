#!/bin/bash
# CIS Benchmark 2.1.11 - Ensure print server services are not in use
echo "Applying remediation for CIS 2.1.11..."
systemctl stop cups.service cups.socket 2>/dev/null
systemctl mask cups.service cups.socket 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' cups 2>/dev/null | grep -q "installed" && apt purge -y cups
echo "Remediation complete for CIS 2.1.11"
