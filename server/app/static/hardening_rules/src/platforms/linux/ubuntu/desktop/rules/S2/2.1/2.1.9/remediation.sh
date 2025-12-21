#!/bin/bash
# CIS Benchmark 2.1.9 - Ensure network file system services are not in use
echo "Applying remediation for CIS 2.1.9..."
systemctl stop nfs-server.service 2>/dev/null
systemctl mask nfs-server.service 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' nfs-kernel-server 2>/dev/null | grep -q "installed" && apt purge -y nfs-kernel-server
echo "Remediation complete for CIS 2.1.9"
