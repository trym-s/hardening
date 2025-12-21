#!/bin/bash
# CIS Benchmark 2.1.13 - Ensure rsync services are not in use
echo "Applying remediation for CIS 2.1.13..."
systemctl stop rsync.service 2>/dev/null
systemctl mask rsync.service 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' rsync 2>/dev/null | grep -q "installed" && apt purge -y rsync
echo "Remediation complete for CIS 2.1.13"