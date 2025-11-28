#!/bin/bash
# 2.1.12 Ensure rpcbind services are not in use

systemctl stop rpcbind
systemctl disable rpcbind
apt purge rpcbind -y
