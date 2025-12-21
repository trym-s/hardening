#!/bin/bash
# CIS Benchmark 2.1.17 - Ensure tftp server services are not in use
echo "Applying remediation for CIS 2.1.17..."
systemctl stop tftpd-hpa.service 2>/dev/null
systemctl mask tftpd-hpa.service 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' tftpd-hpa 2>/dev/null | grep -q "installed" && apt purge -y tftpd-hpa
echo "Remediation complete for CIS 2.1.17"
