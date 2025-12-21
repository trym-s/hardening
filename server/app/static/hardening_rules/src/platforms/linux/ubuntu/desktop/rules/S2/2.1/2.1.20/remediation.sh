#!/bin/bash
# CIS Benchmark 2.1.20 - Ensure xinetd services are not in use
echo "Applying remediation for CIS 2.1.20..."
systemctl stop xinetd.service 2>/dev/null
systemctl mask xinetd.service 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' xinetd 2>/dev/null | grep -q "installed" && apt purge -y xinetd
echo "Remediation complete for CIS 2.1.20"
