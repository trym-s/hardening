#!/bin/bash
# 4.4.3.4 Ensure ip6tables firewall rules exist for all open ports

# Get list of open ports (IPv6)
open_ports=$(ss -tuln -6 | awk 'NR>1 {print $5}' | awk -F: '{print $NF}' | sort -u)

# Check if ip6tables has rules for these ports
missing_rule=0
for port in $open_ports; do
    if ! ip6tables -L INPUT -v -n | grep -q "dpt:$port"; then
        echo "Port $port is open but has no ip6tables rule"
        missing_rule=1
    fi
done

if [ "$missing_rule" -eq 0 ]; then
    echo "All open ports have ip6tables rules"
    exit 0
else
    exit 1
fi
