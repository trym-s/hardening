#!/bin/bash
# 4.1.1 Ensure a single firewall configuration utility is in use

# Check for ufw, nftables, and iptables usage
l_ufw=""
l_nftables=""
l_iptables=""

if dpkg-query -W -f='${Status}' ufw 2>/dev/null | grep -q "install ok installed"; then
    if ufw status | grep -q "Status: active"; then
        l_ufw="active"
    fi
fi

if dpkg-query -W -f='${Status}' nftables 2>/dev/null | grep -q "install ok installed"; then
    if systemctl is-active nftables | grep -q "active"; then
        l_nftables="active"
    fi
fi

if dpkg-query -W -f='${Status}' iptables-persistent 2>/dev/null | grep -q "install ok installed"; then
    if systemctl is-active iptables | grep -q "active"; then
        l_iptables="active"
    fi
fi

# Count active firewalls
count=0
[ -n "$l_ufw" ] && ((count++))
[ -n "$l_nftables" ] && ((count++))
[ -n "$l_iptables" ] && ((count++))

if [ "$count" -eq 1 ]; then
    echo "PASSED: Only one firewall utility is active"
    exit 0
elif [ "$count" -eq 0 ]; then
    echo "FAILED: No firewall utility is active"
    exit 1
else
    echo "FAILED: Multiple firewall utilities are active"
    exit 1
fi
