#!/bin/bash
echo "Checking if filesystem integrity check is scheduled..."
if crontab -l 2>/dev/null | grep -q "aide" || \
   grep -r "aide" /etc/cron.* /etc/crontab 2>/dev/null | grep -v "^#"; then
    echo "PASS: AIDE is scheduled"
    exit 0
else
    echo "FAIL: AIDE integrity check is not scheduled"
    exit 1
fi
