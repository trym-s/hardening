#!/bin/bash
# CIS 4.2.1 Ensure ufw is installed

echo "Applying remediation for CIS 4.2.1..."

apt-get install -y ufw

echo "Remediation complete for CIS 4.2.1"
