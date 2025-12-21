#!/bin/bash
echo "Checking audit log file ownership..."
find /var/log/audit -type f ! -user root -ls && echo "FAIL" && exit 1
echo "PASS"
exit 0
