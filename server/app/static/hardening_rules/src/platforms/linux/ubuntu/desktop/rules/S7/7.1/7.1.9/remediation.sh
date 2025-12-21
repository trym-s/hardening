#!/bin/bash

# 7.1.9 Ensure permissions on /etc/shells are configured (Automated)

echo "Configuring permissions on /etc/shells..."

chown root:root /etc/shells
chmod u-x,go-wx /etc/shells

echo "/etc/shells permissions have been configured"
