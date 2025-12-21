#!/bin/bash

# Remediate permissions on SSH public host key files
echo "Setting permissions on SSH public host key files..."

find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod 644 {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;

echo "SUCCESS: All SSH public host key files secured"
