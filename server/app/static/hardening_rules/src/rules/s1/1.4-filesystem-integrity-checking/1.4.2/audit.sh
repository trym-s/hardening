#!/bin/bash
if systemctl is-enabled dailyaidecheck.timer >/dev/null 2>&1; then
    echo "dailyaidecheck.timer is enabled"
    exit 0
else
    echo "dailyaidecheck.timer is NOT enabled"
    exit 1
fi
