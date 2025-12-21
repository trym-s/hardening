#!/bin/bash
# CIS 3.3.11 Ensure IPv6 router advertisements are not accepted

echo "Applying remediation for CIS 3.3.11..."

cat >> /etc/sysctl.d/60-netipv6_sysctl.conf << 'EOF'
# CIS 3.3.11 - Do not accept IPv6 router advertisements
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
EOF

sysctl -w net.ipv6.conf.all.accept_ra=0 2>/dev/null
sysctl -w net.ipv6.conf.default.accept_ra=0 2>/dev/null
sysctl -w net.ipv6.route.flush=1 2>/dev/null

echo "Remediation complete for CIS 3.3.11"
