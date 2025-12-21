#!/bin/bash

# CIS 5.4.1.1 - Ensure password expiration is configured
# Set PASS_MAX_DAYS to 365 days

PASS_MAX_DAYS=365

echo "Setting password expiration to $PASS_MAX_DAYS days..."

# Update /etc/login.defs
if grep -q '^PASS_MAX_DAYS' /etc/login.defs; then
    sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t$PASS_MAX_DAYS/" /etc/login.defs
else
    echo "PASS_MAX_DAYS	$PASS_MAX_DAYS" >> /etc/login.defs
fi

echo "Updated /etc/login.defs"

# Update existing users with password set
echo "Updating existing user accounts..."
awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1)system ("chage --maxdays 365 " $1)}' /etc/shadow

echo "SUCCESS: Password expiration configured to $PASS_MAX_DAYS days"
