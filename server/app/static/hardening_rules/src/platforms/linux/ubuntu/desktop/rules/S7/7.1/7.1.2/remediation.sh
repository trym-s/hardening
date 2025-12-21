#!/bin/bash

# 7.1.2 Ensure permissions on /etc/passwd- are configured (Automated)

echo "Configuring permissions on /etc/passwd-..."

chown root:root /etc/passwd-
chmod u-x,go-wx /etc/passwd-

echo "/etc/passwd- permissions have been configured"
