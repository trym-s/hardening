#!/bin/bash
systemctl stop vsftpd
systemctl disable vsftpd
apt purge vsftpd -y
