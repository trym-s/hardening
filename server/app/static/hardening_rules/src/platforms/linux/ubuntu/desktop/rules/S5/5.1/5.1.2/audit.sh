#!/bin/bash

# Check permissions on SSH private host key files
failed=0
while IFS= read -r file; do
    actual=$(stat -Lc "%a %u %g" "$file" 2>/dev/null)
    if [ "$actual" != "600 0 0" ]; then
        echo "FAIL: $file has incorrect permissions"
        echo "  Expected: 600 0 0"
        echo "  Actual: $actual"
        failed=1
    fi
done < <(find /etc/ssh -xdev -type f -name 'ssh_host_*_key' 2>/dev/null)

if [ $failed -eq 0 ]; then
    echo "PASS: All SSH private host key files have correct permissions"
    exit 0
else
    exit 1
fi
