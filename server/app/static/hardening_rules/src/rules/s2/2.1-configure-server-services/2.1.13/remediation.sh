#!/bin/bash
# 2.1.13 Ensure rsync services are not in use

systemctl stop rsync
systemctl disable rsync
apt purge rsync -y