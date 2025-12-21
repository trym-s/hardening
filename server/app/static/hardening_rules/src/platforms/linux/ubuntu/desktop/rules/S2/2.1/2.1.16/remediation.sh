#!/bin/bash
# CIS Benchmark 2.1.16 - Ensure telnet server services are not in use
echo "Applying remediation for CIS 2.1.16..."
systemctl stop telnet.socket 2>/dev/null
systemctl mask telnet.socket 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' telnetd 2>/dev/null | grep -q "installed" && apt purge -y telnetd
echo "Remediation complete for CIS 2.1.16"
