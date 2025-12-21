#!/bin/bash
# CIS 3.3.3 Ensure bogus ICMP responses are ignored

echo "Applying remediation for CIS 3.3.3..."

cat >> /etc/sysctl.d/60-netipv4_sysctl.conf << 'EOF'
# CIS 3.3.3 - Ignore bogus ICMP responses
net.ipv4.icmp_ignore_bogus_error_responses = 1
EOF

sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.route.flush=1

echo "Remediation complete for CIS 3.3.3"
