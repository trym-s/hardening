#!/bin/bash
# CIS 4.1.1 Ensure a single firewall configuration utility is in use

echo "Checking firewall configuration utilities..."

UFW_ENABLED=0
NFTABLES_ENABLED=0
IPTABLES_RULES=0

# Check UFW status
if systemctl is-enabled ufw.service 2>/dev/null | grep -q "enabled"; then
    UFW_ENABLED=1
    echo "INFO: ufw.service is enabled"
fi

if ufw status 2>/dev/null | grep -q "Status: active"; then
    UFW_ENABLED=1
    echo "INFO: ufw is active"
fi

# Check nftables status
if systemctl is-enabled nftables.service 2>/dev/null | grep -q "enabled"; then
    NFTABLES_ENABLED=1
    echo "INFO: nftables.service is enabled"
fi

# Check if iptables has rules (beyond defaults)
IPTABLES_COUNT=$(iptables -L 2>/dev/null | grep -cE "^(ACCEPT|DROP|REJECT)" || echo "0")
if [ "$IPTABLES_COUNT" -gt 0 ]; then
    IPTABLES_RULES=1
    echo "INFO: iptables has active rules"
fi

# Count active firewalls
ACTIVE_COUNT=$((UFW_ENABLED + NFTABLES_ENABLED))

echo ""
echo "Firewall Status Summary:"
echo "  UFW enabled: $([ $UFW_ENABLED -eq 1 ] && echo 'Yes' || echo 'No')"
echo "  nftables enabled: $([ $NFTABLES_ENABLED -eq 1 ] && echo 'Yes' || echo 'No')"
echo "  iptables rules present: $([ $IPTABLES_RULES -eq 1 ] && echo 'Yes' || echo 'No')"
echo ""

if [ "$ACTIVE_COUNT" -eq 1 ]; then
    echo "AUDIT RESULT: PASS - Single firewall utility is in use"
    exit 0
elif [ "$ACTIVE_COUNT" -eq 0 ]; then
    echo "AUDIT RESULT: FAIL - No firewall utility is enabled"
    exit 1
else
    echo "AUDIT RESULT: FAIL - Multiple firewall utilities are enabled"
    exit 1
fi
