#!/bin/bash
# 3.3.9 Ensure suspicious packets are logged

sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1

for param in net.ipv4.conf.all.log_martians net.ipv4.conf.default.log_martians; do
    if grep -q "^$param" /etc/sysctl.conf; then
        sed -i "s/^$param.*/$param = 1/" /etc/sysctl.conf
    else
        echo "$param = 1" >> /etc/sysctl.conf
    fi
done
