#!/bin/bash

# 6.1.4.1 Ensure access to all logfiles has been configured (Automated)

echo "Checking access permissions for all logfiles..."

# Find all log files and check their permissions
find /var/log -type f -exec stat -Lc "%n %a %U %G" {} \; 2>/dev/null | while read -r file perms owner group; do
    # Check if permissions are 640 or more restrictive
    if [[ ! "$perms" =~ ^[0-6][0-4]0$ ]]; then
        echo "WARNING: $file has permissions $perms (owner: $owner, group: $group)"
        failed=1
    fi
done

# Check specific important log files
important_logs="/var/log/syslog /var/log/auth.log /var/log/kern.log /var/log/messages"
all_pass=true

for log in $important_logs; do
    if [ -f "$log" ]; then
        perms=$(stat -Lc "%a" "$log" 2>/dev/null)
        owner=$(stat -Lc "%U" "$log" 2>/dev/null)

        if [[ ! "$perms" =~ ^[0-6][0-4]0$ ]]; then
            echo "FAIL: $log has permissions $perms (should be 640 or more restrictive)"
            all_pass=false
        fi

        if [ "$owner" != "root" ] && [ "$owner" != "syslog" ]; then
            echo "FAIL: $log is owned by $owner (should be root or syslog)"
            all_pass=false
        fi
    fi
done

if $all_pass; then
    echo "PASS: All checked logfiles have appropriate access permissions"
    exit 0
else
    echo "FAIL: Some logfiles have inappropriate access permissions"
    exit 1
fi
