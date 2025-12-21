#!/bin/bash

# Check permissions on SSH public host key files
failed=0
while IFS= read -r file; do
    actual=$(stat -Lc "%a %u %g" "$file" 2>/dev/null)
    perm=$(echo "$actual" | awk '{print $1}')
    owner=$(echo "$actual" | awk '{print $2}')
    group=$(echo "$actual" | awk '{print $3}')
    
    if [ "$owner" != "0" ] || [ "$group" != "0" ]; then
        echo "FAIL: $file has incorrect ownership"
        echo "  Expected owner:group: 0:0"
        echo "  Actual: $owner:$group"
        failed=1
    elif [ "$perm" -gt 644 ]; then
        echo "FAIL: $file has incorrect permissions"
        echo "  Expected: 644 or more restrictive"
        echo "  Actual: $perm"
        failed=1
    fi
done < <(find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' 2>/dev/null)

if [ $failed -eq 0 ]; then
    echo "PASS: All SSH public host key files have correct permissions"
    exit 0
else
    exit 1
fi
