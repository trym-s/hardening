#!/bin/bash
# CIS 3.3.2 Ensure packet redirect sending is disabled

echo "Applying remediation for CIS 3.3.2..."

cat >> /etc/sysctl.d/60-netipv4_sysctl.conf << 'EOF'
# CIS 3.3.2 - Disable packet redirect sending
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
EOF

sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.route.flush=1

echo "Remediation complete for CIS 3.3.2"
