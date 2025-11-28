#!/bin/bash
# 4.4.1.2 Ensure nftables is not in use with iptables

systemctl stop nftables
systemctl mask nftables
