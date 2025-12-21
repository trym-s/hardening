#!/bin/bash
# CIS Benchmark 2.2.2 - Ensure ldap client is not installed
echo "Applying remediation for CIS 2.2.2..."
status=$(dpkg-query -W -f='${db:Status-Status}' ldap-utils 2>/dev/null)
[ "$status" = "installed" ] && apt purge -y ldap-utils
echo "Remediation complete for CIS 2.2.2"
