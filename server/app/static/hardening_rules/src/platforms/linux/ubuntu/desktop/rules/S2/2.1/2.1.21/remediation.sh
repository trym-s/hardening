#!/bin/bash
# CIS Benchmark 2.1.21 - Ensure X window server services are not in use
echo "Applying remediation for CIS 2.1.21..."
echo "WARNING: This will remove X Window server packages and may affect GUI functionality"
apt purge -y 'xserver-xorg*' 2>/dev/null
echo "Remediation complete for CIS 2.1.21"
