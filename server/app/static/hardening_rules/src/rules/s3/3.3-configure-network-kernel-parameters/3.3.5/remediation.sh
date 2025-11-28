#!/bin/bash
# 3.3.5 Ensure icmp redirects are not accepted

sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0

for param in net.ipv4.conf.all.accept_redirects net.ipv4.conf.default.accept_redirects; do
    if grep -q "^$param" /etc/sysctl.conf; then
        sed -i "s/^$param.*/$param = 0/" /etc/sysctl.conf
    else
        echo "$param = 0" >> /etc/sysctl.conf
    fi
done
