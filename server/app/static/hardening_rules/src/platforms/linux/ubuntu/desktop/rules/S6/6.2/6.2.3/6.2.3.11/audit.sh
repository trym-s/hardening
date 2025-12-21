#!/bin/bash
# 6.2.3.11 Ensure session initiation information is collected (Automated)
echo "Checking if session initiation is collected..."
files="/var/run/utmp /var/log/wtmp /var/log/btmp"
all_monitored=true
for file in $files; do
    if ! auditctl -l 2>/dev/null | grep -q "$file"; then
        echo "FAIL: $file not monitored"
        all_monitored=false
    fi
done
$all_monitored && echo "PASS" && exit 0 || exit 1
