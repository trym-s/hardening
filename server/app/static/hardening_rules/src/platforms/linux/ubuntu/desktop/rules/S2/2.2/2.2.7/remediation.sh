#!/bin/bash
# CIS Benchmark 2.2.7 - Ensure tftp client is not installed
echo "Applying remediation for CIS 2.2.7..."
status=$(dpkg-query -W -f='${db:Status-Status}' tftp 2>/dev/null)
[ "$status" = "installed" ] && apt purge -y tftp
echo "Remediation complete for CIS 2.2.7"
