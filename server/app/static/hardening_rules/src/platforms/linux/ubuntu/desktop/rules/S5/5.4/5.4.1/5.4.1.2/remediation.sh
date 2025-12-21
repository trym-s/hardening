#!/bin/bash

# CIS 5.4.1.2 - Ensure minimum password days is configured
# Set PASS_MIN_DAYS to 1 day

PASS_MIN_DAYS=1

echo "Setting minimum password days to $PASS_MIN_DAYS..."

# Update /etc/login.defs
if grep -q '^PASS_MIN_DAYS' /etc/login.defs; then
    sed -i "s/^PASS_MIN_DAYS.*/PASS_MIN_DAYS\t$PASS_MIN_DAYS/" /etc/login.defs
else
    echo "PASS_MIN_DAYS	$PASS_MIN_DAYS" >> /etc/login.defs
fi

echo "Updated /etc/login.defs"

# Update existing users with password set
echo "Updating existing user accounts..."
awk -F: '($2~/^\$.+\$/) {if($4 < 1)system ("chage --mindays 1 " $1)}' /etc/shadow

echo "SUCCESS: Minimum password days configured to $PASS_MIN_DAYS day(s)"
