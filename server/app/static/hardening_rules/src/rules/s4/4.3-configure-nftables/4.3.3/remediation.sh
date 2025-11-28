#!/bin/bash
# 4.3.3 Ensure iptables are flushed with nftables

iptables -F
ip6tables -F
