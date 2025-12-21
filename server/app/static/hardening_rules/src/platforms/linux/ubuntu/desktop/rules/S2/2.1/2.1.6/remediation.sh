#!/bin/bash
# CIS Benchmark 2.1.6 - Ensure ftp server services are not in use
# Remediation Script

echo "Applying remediation for CIS 2.1.6..."

systemctl stop vsftpd.service 2>/dev/null
systemctl mask vsftpd.service 2>/dev/null

if dpkg-query -W -f='${db:Status-Status}' vsftpd 2>/dev/null | grep -q "installed"; then
    apt purge -y vsftpd
fi

echo "Remediation complete for CIS 2.1.6"
