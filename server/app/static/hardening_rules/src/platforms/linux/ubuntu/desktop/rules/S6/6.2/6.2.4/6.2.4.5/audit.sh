#!/bin/bash
# 6.2.4.5 Ensure audit configuration file mode is configured

echo "Checking audit config file permissions..."

FAIL_COUNT=0

if [ -d /etc/audit ]; then
    while IFS= read -r line; do
        perm=$(echo "$line" | awk '{print $1}')
        file=$(echo "$line" | awk '{print $2}')
        # Permission should be 0640 or more restrictive
        if [ "$perm" -gt 640 ] 2>/dev/null; then
            echo "FAIL: $file has permission $perm (should be 0640 or less)"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    done < <(find /etc/audit -type f -exec stat -c "%a %n" {} \;)
else
    echo "INFO: /etc/audit directory does not exist"
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
