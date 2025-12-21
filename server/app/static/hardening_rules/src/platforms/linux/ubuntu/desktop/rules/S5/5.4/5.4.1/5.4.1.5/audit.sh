#!/bin/bash

# CIS 5.4.1.5 - Ensure inactive password lock is configured
# Check INACTIVE setting for password accounts

INACTIVE_MAX=45

echo "Checking inactive password lock configuration..."

# Check default INACTIVE setting
inactive_default=$(useradd -D | grep INACTIVE | cut -d= -f2)

if [ -z "$inactive_default" ] || [ "$inactive_default" -lt 0 ] || [ "$inactive_default" -gt $INACTIVE_MAX ]; then
    echo "FAIL: Default INACTIVE is $inactive_default (should be between 0 and $INACTIVE_MAX)"
    exit 1
fi

echo "Default INACTIVE is set to $inactive_default days"

# Check all users with password set
echo ""
echo "Checking user accounts..."
users_fail=$(awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)print "User: " $1 " INACTIVE: " $7}' /etc/shadow)

if [ -n "$users_fail" ]; then
    echo "FAIL: The following users have incorrect INACTIVE setting:"
    echo "$users_fail"
    exit 1
fi

echo "PASS: Inactive password lock is correctly configured"
exit 0
