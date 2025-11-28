#!/bin/bash
# 2.1.18 Ensure web server services are not in use

systemctl stop apache2
systemctl disable apache2
apt purge apache2 -y

systemctl stop nginx
systemctl disable nginx
apt purge nginx -y
