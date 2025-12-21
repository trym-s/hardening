#!/bin/bash

# 7.1.4 Ensure permissions on /etc/group- are configured (Automated)

echo "Configuring permissions on /etc/group-..."

chown root:root /etc/group-
chmod u-x,go-wx /etc/group-

echo "/etc/group- permissions have been configured"
