#!/bin/bash
# 2.1.15 Ensure snmp services are not in use

# Check if snmpd is enabled
if systemctl is-enabled snmpd | grep -q 'enabled'; then
  echo "FAILED: snmpd is enabled"
  exit 1
fi

# Check if snmpd is active
if systemctl is-active snmpd | grep -q 'active'; then
  echo "FAILED: snmpd is active"
  exit 1
fi

echo "PASSED: snmp services are not in use"
exit 0
