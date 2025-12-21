#!/bin/bash
# CIS 4.4.1 Configure iptables (IPv4)

echo "Applying remediation for CIS 4.4.1..."
echo ""
echo "WARNING: This configures basic iptables rules."
echo "Most Ubuntu 24.04 systems should use nftables instead."
echo ""

# Flush existing rules
iptables -F

# Set default policies to DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -s 127.0.0.0/8 -j DROP

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Allow SSH
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

echo "Basic iptables rules configured"
echo "Remediation complete for CIS 4.4.1"
