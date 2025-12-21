#!/bin/bash
# CIS Benchmark 2.2.5 - Ensure talk client is not installed
echo "Applying remediation for CIS 2.2.5..."
status=$(dpkg-query -W -f='${db:Status-Status}' talk 2>/dev/null)
[ "$status" = "installed" ] && apt purge -y talk
echo "Remediation complete for CIS 2.2.5"
