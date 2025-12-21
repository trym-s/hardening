#!/bin/bash

# CIS 5.4.1.2 - Ensure minimum password days is configured
# Check PASS_MIN_DAYS in /etc/login.defs

echo "Checking minimum password days configuration..."

# Check /etc/login.defs for PASS_MIN_DAYS
pass_min_days=$(grep -Pi -- '^\h*PASS_MIN_DAYS\h+\d+\b' /etc/login.defs | awk '{print $2}')

if [ -z "$pass_min_days" ]; then
    echo "FAIL: PASS_MIN_DAYS is not set in /etc/login.defs"
    exit 1
fi

if [ "$pass_min_days" -lt 1 ]; then
    echo "FAIL: PASS_MIN_DAYS is set to $pass_min_days (should be at least 1)"
    exit 1
fi

echo "PASS_MIN_DAYS is set to $pass_min_days in /etc/login.defs"

# Check all users with password set
echo ""
echo "Checking user accounts..."
users_fail=$(awk -F: '($2~/^\$.+\$/) {if($4 < 1)print "User: " $1 " PASS_MIN_DAYS: " $4}' /etc/shadow)

if [ -n "$users_fail" ]; then
    echo "FAIL: The following users have incorrect PASS_MIN_DAYS:"
    echo "$users_fail"
    exit 1
fi

echo "PASS: Minimum password days is correctly configured"
exit 0
