#!/bin/bash
# CIS Benchmark 2.1.18 - Ensure web proxy server services are not in use
echo "Applying remediation for CIS 2.1.18..."
systemctl stop squid.service 2>/dev/null
systemctl mask squid.service 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' squid 2>/dev/null | grep -q "installed" && apt purge -y squid
echo "Remediation complete for CIS 2.1.18"
