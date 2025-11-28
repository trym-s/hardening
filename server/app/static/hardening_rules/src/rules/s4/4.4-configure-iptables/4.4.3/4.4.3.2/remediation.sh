#!/bin/bash
# 4.4.3.2 Ensure ip6tables loopback traffic is configured

ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT
ip6tables -A INPUT -s ::1 -j DROP
