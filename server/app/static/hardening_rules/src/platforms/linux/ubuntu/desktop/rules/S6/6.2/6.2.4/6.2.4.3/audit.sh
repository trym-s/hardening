#!/bin/bash
echo "Checking audit log file group..."
find /var/log/audit -type f ! -group root -ls && echo "FAIL" && exit 1
echo "PASS"
exit 0
