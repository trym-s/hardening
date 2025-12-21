#!/bin/bash

# CIS 5.4.1.3 - Ensure password expiration warning days is configured
# Set PASS_WARN_AGE to 7 days

PASS_WARN_AGE=7

echo "Setting password warning days to $PASS_WARN_AGE..."

# Update /etc/login.defs
if grep -q '^PASS_WARN_AGE' /etc/login.defs; then
    sed -i "s/^PASS_WARN_AGE.*/PASS_WARN_AGE\t$PASS_WARN_AGE/" /etc/login.defs
else
    echo "PASS_WARN_AGE	$PASS_WARN_AGE" >> /etc/login.defs
fi

echo "Updated /etc/login.defs"

# Update existing users with password set
echo "Updating existing user accounts..."
awk -F: '($2~/^\$.+\$/) {if($6 < 7)system ("chage --warndays 7 " $1)}' /etc/shadow

echo "SUCCESS: Password warning days configured to $PASS_WARN_AGE days"
