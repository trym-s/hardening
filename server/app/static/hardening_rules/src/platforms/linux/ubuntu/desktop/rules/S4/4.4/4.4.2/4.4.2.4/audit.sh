#!/bin/bash
# 4.4.2.4 Ensure iptables firewall rules exist for all open ports

# Get list of open ports
open_ports=$(ss -tuln | awk 'NR>1 {print $5}' | awk -F: '{print $NF}' | sort -u)

# Check if iptables has rules for these ports
missing_rule=0
for port in $open_ports; do
    if ! iptables -L INPUT -v -n | grep -q "dpt:$port"; then
        echo "Port $port is open but has no iptables rule"
        missing_rule=1
    fi
done

if [ "$missing_rule" -eq 0 ]; then
    echo "All open ports have iptables rules"
    exit 0
else
    exit 1
fi
