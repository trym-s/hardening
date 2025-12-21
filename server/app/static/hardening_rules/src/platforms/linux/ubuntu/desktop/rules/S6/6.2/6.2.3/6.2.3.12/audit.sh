#!/bin/bash
# 6.2.3.12 Ensure login and logout events are collected (Automated)
echo "Checking if login/logout events are collected..."
files="/var/log/lastlog /var/log/faillog"
all_monitored=true
for file in $files; do
    if ! auditctl -l 2>/dev/null | grep -q "$file"; then
        echo "FAIL: $file is not monitored"
        all_monitored=false
    fi
done
$all_monitored && echo "PASS" && exit 0 || exit 1
