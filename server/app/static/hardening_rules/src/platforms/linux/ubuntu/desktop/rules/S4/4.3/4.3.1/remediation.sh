#!/bin/bash
# CIS 4.3.1 Ensure nftables is installed

echo "Applying remediation for CIS 4.3.1..."

apt-get install -y nftables

echo "Remediation complete for CIS 4.3.1"
