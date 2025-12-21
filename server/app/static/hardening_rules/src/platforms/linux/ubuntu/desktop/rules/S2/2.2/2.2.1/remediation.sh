#!/bin/bash
# CIS Benchmark 2.2.1 - Ensure ftp client is not installed
echo "Applying remediation for CIS 2.2.1..."
status=$(dpkg-query -W -f='${db:Status-Status}' ftp 2>/dev/null)
[ "$status" = "installed" ] && apt purge -y ftp
echo "Remediation complete for CIS 2.2.1"
