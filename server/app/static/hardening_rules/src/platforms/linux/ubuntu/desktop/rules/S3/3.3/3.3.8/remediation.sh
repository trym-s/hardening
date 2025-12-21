#!/bin/bash
# CIS 3.3.8 Ensure source routed packets are not accepted

echo "Applying remediation for CIS 3.3.8..."

cat >> /etc/sysctl.d/60-netipv4_sysctl.conf << 'EOF'
# CIS 3.3.8 - Do not accept source routed packets
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
EOF

cat >> /etc/sysctl.d/60-netipv6_sysctl.conf << 'EOF'
# CIS 3.3.8 - Do not accept source routed packets (IPv6)
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
EOF

sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0
sysctl -w net.ipv6.conf.all.accept_source_route=0 2>/dev/null
sysctl -w net.ipv6.conf.default.accept_source_route=0 2>/dev/null
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv6.route.flush=1 2>/dev/null

echo "Remediation complete for CIS 3.3.8"
