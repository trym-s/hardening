#!/bin/bash
# CIS 4.2.3 Ensure ufw service is enabled

echo "Applying remediation for CIS 4.2.3..."

systemctl unmask ufw.service 2>/dev/null
systemctl enable ufw.service
systemctl start ufw.service

# Enable ufw (bypass interactive prompt)
echo "y" | ufw enable 2>/dev/null

echo "Remediation complete for CIS 4.2.3"
