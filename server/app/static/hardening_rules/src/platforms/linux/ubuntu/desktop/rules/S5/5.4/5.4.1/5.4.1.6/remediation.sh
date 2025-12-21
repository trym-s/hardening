#!/bin/bash

# CIS 5.4.1.6 - Ensure all users last password change date is in the past
# Manual remediation required - investigate and correct users

echo "Checking for users with future password change dates..."

l_output=""
while IFS= read -r l_user; do
    l_change=$(date -d "$(chage --list $l_user | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s 2>/dev/null)
    if [[ "$l_change" -gt "$(date +%s)" ]]; then
        l_output="$l_output $l_user"
        echo "Found user with future date: $l_user"
        # Set the password change date to today
        chage -d "$(date +%Y-%m-%d)" "$l_user"
        echo "  - Set last password change to today for $l_user"
    fi
done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow)

if [ -z "$l_output" ]; then
    echo "No users found with future password change dates"
else
    echo ""
    echo "Remediated users:$l_output"
fi

echo "SUCCESS: Password change dates verified"
