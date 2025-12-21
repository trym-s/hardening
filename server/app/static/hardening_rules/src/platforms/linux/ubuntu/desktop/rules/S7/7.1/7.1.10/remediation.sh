#!/bin/bash

# 7.1.10 Ensure permissions on /etc/security/opasswd are configured (Automated)

echo "Configuring permissions on /etc/security/opasswd..."

if [ -f /etc/security/opasswd ]; then
    chown root:root /etc/security/opasswd
    chmod 0600 /etc/security/opasswd
    echo "/etc/security/opasswd permissions have been configured"
else
    echo "INFO: /etc/security/opasswd does not exist yet"
fi
