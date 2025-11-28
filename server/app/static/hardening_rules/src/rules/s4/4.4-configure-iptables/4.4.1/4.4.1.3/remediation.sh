#!/bin/bash
# 4.4.1.3 Ensure ufw is not in use with iptables

ufw disable
systemctl stop ufw
systemctl mask ufw
