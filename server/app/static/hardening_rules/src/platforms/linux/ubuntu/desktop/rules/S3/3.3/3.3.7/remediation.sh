#!/bin/bash
# CIS 3.3.7 Ensure reverse path filtering is enabled

echo "Applying remediation for CIS 3.3.7..."

cat >> /etc/sysctl.d/60-netipv4_sysctl.conf << 'EOF'
# CIS 3.3.7 - Enable reverse path filtering
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
EOF

sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1
sysctl -w net.ipv4.route.flush=1

echo "Remediation complete for CIS 3.3.7"
