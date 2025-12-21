#!/bin/bash
echo "Setting audit log file owner to root..."
find /var/log/audit -type f -exec chown root {} \;
echo "Done"
