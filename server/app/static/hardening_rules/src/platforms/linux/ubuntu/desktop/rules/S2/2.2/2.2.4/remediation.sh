#!/bin/bash
# CIS Benchmark 2.2.4 - Ensure rsh client is not installed
echo "Applying remediation for CIS 2.2.4..."
status=$(dpkg-query -W -f='${db:Status-Status}' rsh-client 2>/dev/null)
[ "$status" = "installed" ] && apt purge -y rsh-client
echo "Remediation complete for CIS 2.2.4"
