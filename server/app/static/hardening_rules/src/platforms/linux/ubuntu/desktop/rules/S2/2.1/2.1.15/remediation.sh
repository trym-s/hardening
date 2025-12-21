#!/bin/bash
# CIS Benchmark 2.1.15 - Ensure snmp services are not in use
echo "Applying remediation for CIS 2.1.15..."
systemctl stop snmpd.service 2>/dev/null
systemctl mask snmpd.service 2>/dev/null
dpkg-query -W -f='${db:Status-Status}' snmpd 2>/dev/null | grep -q "installed" && apt purge -y snmpd
echo "Remediation complete for CIS 2.1.15"
