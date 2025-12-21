#!/bin/bash

# 6.1.2.4 Ensure journald Storage is configured (Automated)

echo "Checking journald Storage configuration..."

# Check Storage setting
storage=$(grep -E "^Storage=" /etc/systemd/journald.conf 2>/dev/null)

echo "Storage: ${storage:-Not configured (default: auto)}"

if [ -n "$storage" ]; then
    if echo "$storage" | grep -Eqi "persistent|auto"; then
        echo ""
        echo "AUDIT RESULT: PASS - Storage is configured to persistent or auto"
        exit 0
    else
        echo ""
        echo "AUDIT RESULT: FAIL - Storage is set to: $storage (should be persistent or auto)"
        exit 1
    fi
else
    # Default is 'auto' which behaves as 'persistent' if /var/log/journal exists
    # This is acceptable per CIS benchmark
    if [ -d /var/log/journal ]; then
        echo "INFO: /var/log/journal exists, default 'auto' will use persistent storage"
        echo ""
        echo "AUDIT RESULT: PASS - Default 'auto' with /var/log/journal is acceptable"
        exit 0
    else
        echo "INFO: /var/log/journal does not exist"
        echo "Default 'auto' will use volatile storage (logs lost on reboot)"
        echo ""
        echo "AUDIT RESULT: FAIL - Create /var/log/journal or set Storage=persistent"
        exit 1
    fi
fi
