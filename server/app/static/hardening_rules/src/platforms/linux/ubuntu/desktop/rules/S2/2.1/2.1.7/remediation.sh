#!/bin/bash
# CIS Benchmark 2.1.7 - Ensure ldap server services are not in use
echo "Applying remediation for CIS 2.1.7..."
systemctl stop slapd.service 2>/dev/null
systemctl mask slapd.service 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' slapd 2>/dev/null | grep -q "installed" && apt purge -y slapd
echo "Remediation complete for CIS 2.1.7"
