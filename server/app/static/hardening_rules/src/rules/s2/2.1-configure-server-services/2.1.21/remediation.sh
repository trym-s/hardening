#!/bin/bash
# 2.1.21 Ensure mail transfer agent is configured for local-only mode

# This script assumes Postfix is the MTA.
if [ -f /etc/postfix/main.cf ]; then
  postconf -e "inet_interfaces = loopback-only"
  systemctl restart postfix
  echo "Remediated Postfix configuration."
else
  echo "WARNING: Postfix config not found. Manual remediation required for other MTAs."
fi
