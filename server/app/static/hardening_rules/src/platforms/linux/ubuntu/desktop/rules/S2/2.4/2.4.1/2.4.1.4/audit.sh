#!/bin/bash
# CIS 2.4.1.4 Ensure permissions on /etc/cron.daily are configured

echo "Checking /etc/cron.daily permissions..."

FAIL=0

if [ -d /etc/cron.daily ]; then
    PERMS=$(stat -Lc "%a" /etc/cron.daily)
    UID=$(stat -Lc "%u" /etc/cron.daily)
    GID=$(stat -Lc "%g" /etc/cron.daily)
    
    # Check ownership (should be root:root - UID 0, GID 0)
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ]; then
        echo "PASS: /etc/cron.daily is owned by root:root"
    else
        echo "FAIL: /etc/cron.daily is not owned by root:root (UID: $UID, GID: $GID)"
        FAIL=1
    fi
    
    # Check permissions (should be 700 or more restrictive)
    if [ "$PERMS" -le 700 ]; then
        echo "PASS: /etc/cron.daily permissions are $PERMS (700 or more restrictive)"
    else
        echo "FAIL: /etc/cron.daily permissions are $PERMS (should be 700 or more restrictive)"
        FAIL=1
    fi
else
    echo "INFO: /etc/cron.daily does not exist"
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
