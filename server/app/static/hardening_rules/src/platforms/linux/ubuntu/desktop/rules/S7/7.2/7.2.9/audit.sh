#!/bin/bash

# 7.2.9 Ensure local interactive user home directories are configured (Automated)

echo "Checking local interactive user home directories..."

failed=0

# Get list of local interactive users (UID >= 1000 and has a shell)
while IFS=: read -r user uid home shell; do
    if [ "$uid" -ge 1000 ] && [ "$shell" != "/usr/sbin/nologin" ] && [ "$shell" != "/bin/false" ] && [ "$user" != "nobody" ]; then
        # Check if home directory exists
        if [ ! -d "$home" ]; then
            echo "FAIL: Home directory $home for user $user does not exist"
            failed=1
            continue
        fi

        # Check if user owns their home directory
        owner=$(stat -c "%U" "$home" 2>/dev/null)
        if [ "$owner" != "$user" ]; then
            echo "FAIL: Home directory $home is not owned by $user (owned by $owner)"
            failed=1
        fi

        # Check permissions (should be 750 or more restrictive)
        perm=$(stat -c "%a" "$home" 2>/dev/null)
        if [ "$perm" -gt 750 ]; then
            echo "FAIL: Home directory $home has permissions $perm (should be 750 or more restrictive)"
            failed=1
        fi
    fi
done < <(awk -F: '{print $1":"$3":"$6":"$7}' /etc/passwd)

if [ $failed -eq 0 ]; then
    echo "PASS: All local interactive user home directories are properly configured"
    exit 0
else
    exit 1
fi
