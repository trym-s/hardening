#!/bin/bash
# 2.1.14 Ensure samba file server services are not in use

systemctl stop smbd
systemctl disable smbd
apt purge samba -y
