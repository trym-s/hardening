#!/bin/bash
# CIS 3.3.10 Ensure TCP SYN cookies is enabled

echo "Applying remediation for CIS 3.3.10..."

cat >> /etc/sysctl.d/60-netipv4_sysctl.conf << 'EOF'
# CIS 3.3.10 - Enable TCP SYN cookies
net.ipv4.tcp_syncookies = 1
EOF

sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.route.flush=1

echo "Remediation complete for CIS 3.3.10"
