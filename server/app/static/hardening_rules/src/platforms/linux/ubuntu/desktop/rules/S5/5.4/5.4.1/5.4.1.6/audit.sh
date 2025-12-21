#!/bin/bash

# CIS 5.4.1.6 - Ensure all users last password change date is in the past
# Check that no user has a password change date in the future

echo "Checking users' last password change dates..."

l_output=""
while IFS= read -r l_user; do
    l_change=$(date -d "$(chage --list $l_user | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s 2>/dev/null)
    if [[ "$l_change" -gt "$(date +%s)" ]]; then
        l_output="$l_output\nUser: \"$l_user\" last password change was \"$(chage --list $l_user | grep '^Last password change' | cut -d: -f2)\""
    fi
done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow)

if [ -n "$l_output" ]; then
    echo "FAIL: The following users have password change dates in the future:"
    echo -e "$l_output"
    exit 1
fi

echo "PASS: All users' last password change dates are in the past"
exit 0
