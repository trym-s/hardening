#!/bin/bash
echo "Setting audit log file group to root..."
find /var/log/audit -type f -exec chgrp root {} \;
echo "Done"
