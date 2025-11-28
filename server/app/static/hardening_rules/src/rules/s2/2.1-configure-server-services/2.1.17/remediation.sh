#!/bin/bash
# 2.1.17 Ensure web proxy server services are not in use

systemctl stop squid
systemctl disable squid
apt purge squid -y
