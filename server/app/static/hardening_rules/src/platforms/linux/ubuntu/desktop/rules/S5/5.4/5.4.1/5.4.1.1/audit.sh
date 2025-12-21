#!/bin/bash

# CIS 5.4.1.1 - Ensure password expiration is configured
# Check PASS_MAX_DAYS in /etc/login.defs

echo "Checking password expiration configuration..."

# Check /etc/login.defs for PASS_MAX_DAYS
pass_max_days=$(grep -Pi -- '^\h*PASS_MAX_DAYS\h+\d+\b' /etc/login.defs | awk '{print $2}')

if [ -z "$pass_max_days" ]; then
    echo "FAIL: PASS_MAX_DAYS is not set in /etc/login.defs"
    exit 1
fi

if [ "$pass_max_days" -gt 365 ] || [ "$pass_max_days" -lt 1 ]; then
    echo "FAIL: PASS_MAX_DAYS is set to $pass_max_days (should be between 1 and 365)"
    exit 1
fi

echo "PASS_MAX_DAYS is set to $pass_max_days in /etc/login.defs"

# Check all users with password set
echo ""
echo "Checking user accounts..."
users_fail=$(awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1)print "User: " $1 " PASS_MAX_DAYS: " $5}' /etc/shadow)

if [ -n "$users_fail" ]; then
    echo "FAIL: The following users have incorrect PASS_MAX_DAYS:"
    echo "$users_fail"
    exit 1
fi

echo "PASS: Password expiration is correctly configured"
exit 0
