#!/bin/bash
# 4.3.2 Ensure ufw is uninstalled or disabled with nftables

apt-get remove -y ufw iptables-persistent
