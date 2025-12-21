#!/bin/bash
# CIS Benchmark 2.2.3 - Ensure nis client is not installed
echo "Applying remediation for CIS 2.2.3..."
status=$(dpkg-query -W -f='${db:Status-Status}' nis 2>/dev/null)
[ "$status" = "installed" ] && apt purge -y nis
echo "Remediation complete for CIS 2.2.3"
