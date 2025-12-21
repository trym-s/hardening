#!/bin/bash
# CIS 4.3.9 Ensure nftables service is enabled

echo "Applying remediation for CIS 4.3.9..."

systemctl enable nftables.service

echo "Remediation complete for CIS 4.3.9"
