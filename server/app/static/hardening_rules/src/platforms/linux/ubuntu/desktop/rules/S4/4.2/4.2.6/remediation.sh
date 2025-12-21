#!/bin/bash
# CIS 4.2.6 Ensure ufw firewall rules exist for all open ports

echo "Applying remediation for CIS 4.2.6..."

# Allow SSH by default to prevent lockout
ufw allow 22/tcp comment "SSH"

echo ""
echo "Remediation complete for CIS 4.2.6"
echo "NOTE: Add rules for other required ports based on your needs:"
echo "  ufw allow <port>/<tcp|udp>"
