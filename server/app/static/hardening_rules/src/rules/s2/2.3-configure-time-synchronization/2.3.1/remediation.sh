#!/bin/bash
# 2.3.1 Ensure time synchronization is in use

# Defaulting to systemd-timesyncd for Ubuntu
apt install systemd-timesyncd -y
systemctl enable systemd-timesyncd
systemctl start systemd-timesyncd
