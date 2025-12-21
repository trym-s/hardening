#!/bin/bash
# CIS 4.2.4 Ensure ufw loopback traffic is configured

echo "Applying remediation for CIS 4.2.4..."

# Allow loopback traffic
ufw allow in on lo
ufw allow out on lo

# Deny traffic from loopback addresses on non-loopback interfaces
ufw deny in from 127.0.0.0/8
ufw deny in from ::1

echo "Remediation complete for CIS 4.2.4"
