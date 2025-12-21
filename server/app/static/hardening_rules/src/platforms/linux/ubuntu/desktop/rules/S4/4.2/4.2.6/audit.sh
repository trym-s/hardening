#!/bin/bash
# CIS 4.2.6 Ensure ufw firewall rules exist for all open ports

echo "Checking firewall rules for open ports..."
echo ""

echo "Listening ports:"
ss -tuln | grep LISTEN
echo ""

echo "UFW Rules:"
ufw status numbered 2>/dev/null
echo ""

echo "Compare listening ports with UFW rules above."
echo ""
echo "AUDIT RESULT: MANUAL - Verify all open ports have firewall rules"
exit 0
