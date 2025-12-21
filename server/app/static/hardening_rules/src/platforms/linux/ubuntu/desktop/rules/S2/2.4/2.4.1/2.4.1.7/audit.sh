#!/bin/bash
# CIS 2.4.1.7 Ensure permissions on /etc/cron.d are configured

echo "Checking /etc/cron.d permissions..."

FAIL=0

if [ -d /etc/cron.d ]; then
    PERMS=$(stat -Lc "%a" /etc/cron.d)
    UID=$(stat -Lc "%u" /etc/cron.d)
    GID=$(stat -Lc "%g" /etc/cron.d)
    
    # Check ownership (should be root:root - UID 0, GID 0)
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ]; then
        echo "PASS: /etc/cron.d is owned by root:root"
    else
        echo "FAIL: /etc/cron.d is not owned by root:root (UID: $UID, GID: $GID)"
        FAIL=1
    fi
    
    # Check permissions (should be 700 or more restrictive)
    if [ "$PERMS" -le 700 ]; then
        echo "PASS: /etc/cron.d permissions are $PERMS (700 or more restrictive)"
    else
        echo "FAIL: /etc/cron.d permissions are $PERMS (should be 700 or more restrictive)"
        FAIL=1
    fi
else
    echo "INFO: /etc/cron.d does not exist"
    FAIL=0
fi

if [ "$FAIL" -eq 0 ]; then
    echo ""
    echo "AUDIT RESULT: PASS"
    exit 0
else
    echo ""
    echo "AUDIT RESULT: FAIL"
    exit 1
fi
