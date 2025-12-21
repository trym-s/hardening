#!/bin/bash

# 6.2.2.4 Ensure system warns when audit logs are low on space (Automated)

echo "Configuring space left warning for audit logs..."

# Set space_left to 25% of max_log_file (e.g., 75 MB if max_log_file is 100 MB)
sed -i 's/^space_left\s*=.*/space_left = 75/' /etc/audit/auditd.conf
grep -q "^space_left" /etc/audit/auditd.conf || echo "space_left = 75" >> /etc/audit/auditd.conf

# Set admin_space_left to 50 MB
sed -i 's/^admin_space_left\s*=.*/admin_space_left = 50/' /etc/audit/auditd.conf
grep -q "^admin_space_left" /etc/audit/auditd.conf || echo "admin_space_left = 50" >> /etc/audit/auditd.conf

systemctl restart auditd

echo "Space left warnings have been configured"
