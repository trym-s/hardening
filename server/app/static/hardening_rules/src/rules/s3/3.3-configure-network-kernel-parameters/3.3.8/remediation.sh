#!/bin/bash
# 3.3.8 Ensure source routed packets are not accepted

sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0

for param in net.ipv4.conf.all.accept_source_route net.ipv4.conf.default.accept_source_route; do
    if grep -q "^$param" /etc/sysctl.conf; then
        sed -i "s/^$param.*/$param = 0/" /etc/sysctl.conf
    else
        echo "$param = 0" >> /etc/sysctl.conf
    fi
done
