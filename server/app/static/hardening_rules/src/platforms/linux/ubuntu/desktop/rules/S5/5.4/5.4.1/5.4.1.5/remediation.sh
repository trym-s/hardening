#!/bin/bash

# CIS 5.4.1.5 - Ensure inactive password lock is configured
# Set INACTIVE to 45 days

INACTIVE_DAYS=45

echo "Setting inactive password lock to $INACTIVE_DAYS days..."

# Set default inactive period for new users
useradd -D -f $INACTIVE_DAYS
echo "Default INACTIVE set to $INACTIVE_DAYS days for new users"

# Update existing users with password set
echo "Updating existing user accounts..."
awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)system ("chage --inactive 45 " $1)}' /etc/shadow

echo "SUCCESS: Inactive password lock configured to $INACTIVE_DAYS days"
