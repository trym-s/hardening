#!/bin/bash

# Remediate permissions on SSH private host key files
echo "Setting permissions on SSH private host key files..."

find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod 600 {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:root {} \;

echo "SUCCESS: All SSH private host key files secured"
