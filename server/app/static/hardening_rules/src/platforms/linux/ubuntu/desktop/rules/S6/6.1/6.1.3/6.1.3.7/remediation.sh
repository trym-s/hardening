#!/bin/bash

# 6.1.3.7 Ensure rsyslog is not configured to receive logs from a remote client (Automated)

echo "Removing rsyslog remote reception configuration..."

# Comment out or remove remote reception configurations
for conf_file in /etc/rsyslog.conf /etc/rsyslog.d/*.conf; do
    if [ -f "$conf_file" ]; then
        sed -i 's/^\(\$ModLoad imtcp\)/#\1/' "$conf_file"
        sed -i 's/^\(\$InputTCPServerRun\)/#\1/' "$conf_file"
        sed -i 's/^\(\$ModLoad imudp\)/#\1/' "$conf_file"
        sed -i 's/^\(\$UDPServerRun\)/#\1/' "$conf_file"
        sed -i 's/^\(module(load="imtcp")\)/#\1/' "$conf_file"
        sed -i 's/^\(input(type="imtcp"\)/#\1/' "$conf_file"
        sed -i 's/^\(module(load="imudp")\)/#\1/' "$conf_file"
        sed -i 's/^\(input(type="imudp"\)/#\1/' "$conf_file"
    fi
done

systemctl restart rsyslog

echo "rsyslog remote reception has been disabled"
