#!/bin/bash

# 6.2.2.2 Ensure audit logs are not automatically deleted (Automated)

echo "Configuring audit to keep logs..."

# Set max_log_file_action to keep_logs
if grep -q "^max_log_file_action" /etc/audit/auditd.conf; then
    sed -i 's/^max_log_file_action\s*=.*/max_log_file_action = keep_logs/' /etc/audit/auditd.conf
else
    echo "max_log_file_action = keep_logs" >> /etc/audit/auditd.conf
fi

systemctl restart auditd

echo "max_log_file_action has been set to keep_logs"
