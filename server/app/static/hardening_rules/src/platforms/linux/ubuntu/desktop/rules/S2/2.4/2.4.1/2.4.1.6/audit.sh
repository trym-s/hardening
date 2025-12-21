#!/bin/bash
# CIS 2.4.1.6 Ensure permissions on /etc/cron.monthly are configured

echo "Checking /etc/cron.monthly permissions..."

FAIL=0

if [ -d /etc/cron.monthly ]; then
    PERMS=$(stat -Lc "%a" /etc/cron.monthly)
    UID=$(stat -Lc "%u" /etc/cron.monthly)
    GID=$(stat -Lc "%g" /etc/cron.monthly)
    
    # Check ownership (should be root:root - UID 0, GID 0)
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ]; then
        echo "PASS: /etc/cron.monthly is owned by root:root"
    else
        echo "FAIL: /etc/cron.monthly is not owned by root:root (UID: $UID, GID: $GID)"
        FAIL=1
    fi
    
    # Check permissions (should be 700 or more restrictive)
    if [ "$PERMS" -le 700 ]; then
        echo "PASS: /etc/cron.monthly permissions are $PERMS (700 or more restrictive)"
    else
        echo "FAIL: /etc/cron.monthly permissions are $PERMS (should be 700 or more restrictive)"
        FAIL=1
    fi
else
    echo "INFO: /etc/cron.monthly does not exist"
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
