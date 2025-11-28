#!/bin/bash
# 3.3.2 Ensure packet redirect sending is disabled

sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0

for param in net.ipv4.conf.all.send_redirects net.ipv4.conf.default.send_redirects; do
    if grep -q "^$param" /etc/sysctl.conf; then
        sed -i "s/^$param.*/$param = 0/" /etc/sysctl.conf
    else
        echo "$param = 0" >> /etc/sysctl.conf
    fi
done
