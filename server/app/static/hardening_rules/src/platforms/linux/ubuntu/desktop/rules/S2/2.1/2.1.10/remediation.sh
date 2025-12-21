#!/bin/bash
# CIS Benchmark 2.1.10 - Ensure nis server services are not in use
echo "Applying remediation for CIS 2.1.10..."
systemctl stop ypserv.service 2>/dev/null
systemctl mask ypserv.service 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' nis 2>/dev/null | grep -q "installed" && apt purge -y nis
echo "Remediation complete for CIS 2.1.10"
