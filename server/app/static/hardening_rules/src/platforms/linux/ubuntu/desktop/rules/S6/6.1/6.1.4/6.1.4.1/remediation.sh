#!/bin/bash

# 6.1.4.1 Ensure access to all logfiles has been configured (Automated)

echo "Configuring access permissions for logfiles..."

# Set permissions for all log files to 640 or more restrictive
find /var/log -type f -exec chmod g-wx,o-rwx {} \;

# Ensure log files are owned by appropriate users
chown -R root:adm /var/log/

# Set specific permissions for common log files
[ -f /var/log/syslog ] && chmod 640 /var/log/syslog
[ -f /var/log/auth.log ] && chmod 640 /var/log/auth.log
[ -f /var/log/kern.log ] && chmod 640 /var/log/kern.log
[ -f /var/log/messages ] && chmod 640 /var/log/messages

echo "Logfile access permissions have been configured"
