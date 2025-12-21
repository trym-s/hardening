#!/bin/bash
# CIS 3.3.5 Ensure ICMP redirects are not accepted

echo "Applying remediation for CIS 3.3.5..."

cat >> /etc/sysctl.d/60-netipv4_sysctl.conf << 'EOF'
# CIS 3.3.5 - Do not accept ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
EOF

cat >> /etc/sysctl.d/60-netipv6_sysctl.conf << 'EOF'
# CIS 3.3.5 - Do not accept ICMP redirects (IPv6)
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
EOF

sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv6.conf.all.accept_redirects=0 2>/dev/null
sysctl -w net.ipv6.conf.default.accept_redirects=0 2>/dev/null
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv6.route.flush=1 2>/dev/null

echo "Remediation complete for CIS 3.3.5"
