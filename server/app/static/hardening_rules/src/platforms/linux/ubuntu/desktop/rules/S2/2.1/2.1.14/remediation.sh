#!/bin/bash
# CIS Benchmark 2.1.14 - Ensure samba file server services are not in use
echo "Applying remediation for CIS 2.1.14..."
systemctl stop smbd.service nmbd.service 2>/dev/null
systemctl mask smbd.service nmbd.service 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' samba 2>/dev/null | grep -q "installed" && apt purge -y samba
echo "Remediation complete for CIS 2.1.14"
