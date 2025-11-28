#!/bin/bash
# 2.1.19 Ensure xinetd services are not in use

systemctl stop xinetd
systemctl disable xinetd
apt purge xinetd -y
