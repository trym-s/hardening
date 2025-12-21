#!/bin/bash
# CIS 3.3.4 Ensure broadcast ICMP requests are ignored

echo "Applying remediation for CIS 3.3.4..."

cat >> /etc/sysctl.d/60-netipv4_sysctl.conf << 'EOF'
# CIS 3.3.4 - Ignore broadcast ICMP requests
net.ipv4.icmp_echo_ignore_broadcasts = 1
EOF

sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.route.flush=1

echo "Remediation complete for CIS 3.3.4"
