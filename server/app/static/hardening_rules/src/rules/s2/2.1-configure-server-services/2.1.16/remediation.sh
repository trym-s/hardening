#!/bin/bash
# 2.1.16 Ensure tftp server services are not in use

systemctl stop tftpd-hpa
systemctl disable tftpd-hpa
apt purge tftpd-hpa -y
