#!/bin/bash
echo "Setting audit log file permissions to 600..."
find /var/log/audit -type f -exec chmod 600 {} \;
echo "Done"
