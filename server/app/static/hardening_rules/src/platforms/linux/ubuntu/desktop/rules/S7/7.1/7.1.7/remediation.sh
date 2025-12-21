#!/bin/bash

# 7.1.7 Ensure permissions on /etc/gshadow are configured (Automated)

echo "Configuring permissions on /etc/gshadow..."

chown root:root /etc/gshadow
chmod 0000 /etc/gshadow

echo "/etc/gshadow permissions have been configured"
