#!/bin/bash

# 6.2.2.1 Ensure audit log storage size is configured (Automated)

echo "Configuring audit log storage size..."

# Set max_log_file to appropriate size (e.g., 100 MB)
if grep -q "^max_log_file" /etc/audit/auditd.conf; then
    sed -i 's/^max_log_file\s*=.*/max_log_file = 100/' /etc/audit/auditd.conf
else
    echo "max_log_file = 100" >> /etc/audit/auditd.conf
fi

systemctl restart auditd

echo "max_log_file has been set to 100 MB"
