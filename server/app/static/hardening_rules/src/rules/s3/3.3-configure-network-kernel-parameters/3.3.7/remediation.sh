#!/bin/bash
# 3.3.7 Ensure reverse path filtering is enabled

sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1

for param in net.ipv4.conf.all.rp_filter net.ipv4.conf.default.rp_filter; do
    if grep -q "^$param" /etc/sysctl.conf; then
        sed -i "s/^$param.*/$param = 1/" /etc/sysctl.conf
    else
        echo "$param = 1" >> /etc/sysctl.conf
    fi
done
