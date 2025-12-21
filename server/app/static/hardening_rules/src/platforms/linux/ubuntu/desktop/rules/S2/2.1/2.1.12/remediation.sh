#!/bin/bash
# CIS Benchmark 2.1.12 - Ensure rpcbind services are not in use
echo "Applying remediation for CIS 2.1.12..."
systemctl stop rpcbind.service rpcbind.socket 2>/dev/null
systemctl mask rpcbind.service rpcbind.socket 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' rpcbind 2>/dev/null | grep -q "installed" && apt purge -y rpcbind
echo "Remediation complete for CIS 2.1.12"
