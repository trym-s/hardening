#!/bin/bash

# 7.1.6 Ensure permissions on /etc/shadow- are configured (Automated)

echo "Configuring permissions on /etc/shadow-..."

chown root:root /etc/shadow-
chmod 0000 /etc/shadow-

echo "/etc/shadow- permissions have been configured"
