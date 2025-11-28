#!/bin/bash
# 4.2.6 Ensure ufw firewall rules exist for all open ports

# Get list of open ports
open_ports=$(ss -tuln | awk 'NR>1 {print $5}' | awk -F: '{print $NF}' | sort -u)

# Check if ufw has rules for these ports
missing_rule=0
for port in $open_ports; do
    if ! ufw status | grep -q "$port"; then
        echo "Port $port is open but has no ufw rule"
        missing_rule=1
    fi
done

if [ "$missing_rule" -eq 0 ]; then
    echo "All open ports have ufw rules"
    exit 0
else
    exit 1
fi
