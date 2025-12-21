#!/bin/bash
# CIS 4.4.1 Configure iptables (IPv4)

echo "Checking iptables configuration..."
echo ""

# Check if iptables is installed
if command -v iptables &>/dev/null; then
    echo "INFO: iptables is available"
else
    echo "INFO: iptables is not installed"
    echo "AUDIT RESULT: PASS - Not applicable (iptables not installed)"
    exit 0
fi

# Check default policies
echo ""
echo "Current iptables policies:"
iptables -L -n | head -10

echo ""
echo "AUDIT RESULT: MANUAL - Review iptables configuration"
echo "NOTE: Ubuntu 24.04 defaults to nftables"
exit 0
