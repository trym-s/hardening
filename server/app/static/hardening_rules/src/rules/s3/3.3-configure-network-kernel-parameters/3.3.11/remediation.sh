#!/bin/bash
# 3.3.11 Ensure ipv6 router advertisements are not accepted

sysctl -w net.ipv6.conf.all.accept_ra=0
sysctl -w net.ipv6.conf.default.accept_ra=0

for param in net.ipv6.conf.all.accept_ra net.ipv6.conf.default.accept_ra; do
    if grep -q "^$param" /etc/sysctl.conf; then
        sed -i "s/^$param.*/$param = 0/" /etc/sysctl.conf
    else
        echo "$param = 0" >> /etc/sysctl.conf
    fi
done
