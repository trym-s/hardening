#!/bin/bash
# 3.3.6 Ensure secure icmp redirects are not accepted

sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0

for param in net.ipv4.conf.all.secure_redirects net.ipv4.conf.default.secure_redirects; do
    if grep -q "^$param" /etc/sysctl.conf; then
        sed -i "s/^$param.*/$param = 0/" /etc/sysctl.conf
    else
        echo "$param = 0" >> /etc/sysctl.conf
    fi
done
