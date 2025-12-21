#!/bin/bash
# CIS Benchmark 2.1.19 - Ensure web server services are not in use
echo "Applying remediation for CIS 2.1.19..."
systemctl stop apache2.service nginx.service 2>/dev/null
systemctl mask apache2.service nginx.service 2>/dev/null
apt purge -y apache2 nginx 2>/dev/null
echo "Remediation complete for CIS 2.1.19"
