#!/bin/bash
# 4.4.2.2 Ensure iptables loopback traffic is configured

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -s 127.0.0.0/8 -j DROP
