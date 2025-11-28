#!/bin/bash
# 4.4.2.1 Ensure iptables default deny firewall policy

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
