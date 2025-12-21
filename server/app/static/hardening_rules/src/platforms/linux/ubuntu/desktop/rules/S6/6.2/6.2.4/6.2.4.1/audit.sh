#!/bin/bash
# 6.2.4.1 Ensure audit log file mode is configured

echo "Checking audit log file permissions..."

FAIL_COUNT=0

if [ -d /var/log/audit ]; then
    while IFS= read -r line; do
        perm=$(echo "$line" | awk '{print $1}')
        file=$(echo "$line" | awk '{print $2}')
        # Permission should be 0600 or more restrictive
        if [ "$perm" -gt 600 ] 2>/dev/null; then
            echo "FAIL: $file has permission $perm (should be 0600 or less)"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    done < <(find /var/log/audit -type f -exec stat -c "%a %n" {} \;)
else
    echo "INFO: /var/log/audit directory does not exist"
fi

if [ "$FAIL_COUNT" -gt 0 ]; then
    echo ""
    echo "AUDIT RESULT: FAIL - $FAIL_COUNT file(s) have incorrect permissions"
    exit 1
else
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
fi
