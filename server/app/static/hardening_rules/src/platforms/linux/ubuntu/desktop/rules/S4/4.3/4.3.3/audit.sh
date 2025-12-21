#!/bin/bash
# CIS 4.3.3 Ensure iptables are flushed with nftables

echo "Checking iptables rules..."

IPT_RULES=$(iptables -L 2>/dev/null | grep -cE "^(ACCEPT|DROP|REJECT)")
IP6T_RULES=$(ip6tables -L 2>/dev/null | grep -cE "^(ACCEPT|DROP|REJECT)")

echo "iptables rules count: $IPT_RULES"
echo "ip6tables rules count: $IP6T_RULES"

if [ "$IPT_RULES" -eq 0 ] && [ "$IP6T_RULES" -eq 0 ]; then
    echo ""
    echo "AUDIT RESULT: PASS - iptables are flushed"
    exit 0
else
    echo ""
    echo "AUDIT RESULT: MANUAL - Review iptables rules before flushing"
    exit 0
fi
