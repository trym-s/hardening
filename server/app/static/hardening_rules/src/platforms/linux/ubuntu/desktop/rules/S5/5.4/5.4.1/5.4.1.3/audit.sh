#!/bin/bash

# CIS 5.4.1.3 - Ensure password expiration warning days is configured
# Check PASS_WARN_AGE in /etc/login.defs

echo "Checking password expiration warning days configuration..."

# Check /etc/login.defs for PASS_WARN_AGE
pass_warn_age=$(grep -Pi -- '^\h*PASS_WARN_AGE\h+\d+\b' /etc/login.defs | awk '{print $2}')

if [ -z "$pass_warn_age" ]; then
    echo "FAIL: PASS_WARN_AGE is not set in /etc/login.defs"
    exit 1
fi

if [ "$pass_warn_age" -lt 7 ]; then
    echo "FAIL: PASS_WARN_AGE is set to $pass_warn_age (should be at least 7)"
    exit 1
fi

echo "PASS_WARN_AGE is set to $pass_warn_age in /etc/login.defs"

# Check all users with password set
echo ""
echo "Checking user accounts..."
users_fail=$(awk -F: '($2~/^\$.+\$/) {if($6 < 7)print "User: " $1 " PASS_WARN_AGE: " $6}' /etc/shadow)

if [ -n "$users_fail" ]; then
    echo "FAIL: The following users have incorrect PASS_WARN_AGE:"
    echo "$users_fail"
    exit 1
fi

echo "PASS: Password expiration warning days is correctly configured"
exit 0
