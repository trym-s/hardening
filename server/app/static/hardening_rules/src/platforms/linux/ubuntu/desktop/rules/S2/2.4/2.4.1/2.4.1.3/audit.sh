#!/bin/bash
# CIS 2.4.1.3 Ensure permissions on /etc/cron.hourly are configured

echo "Checking /etc/cron.hourly permissions..."

FAIL=0

if [ -d /etc/cron.hourly ]; then
    PERMS=$(stat -Lc "%a" /etc/cron.hourly)
    UID=$(stat -Lc "%u" /etc/cron.hourly)
    GID=$(stat -Lc "%g" /etc/cron.hourly)
    
    # Check ownership (should be root:root - UID 0, GID 0)
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ]; then
        echo "PASS: /etc/cron.hourly is owned by root:root"
    else
        echo "FAIL: /etc/cron.hourly is not owned by root:root (UID: $UID, GID: $GID)"
        FAIL=1
    fi
    
    # Check permissions (should be 700 or more restrictive)
    if [ "$PERMS" -le 700 ]; then
        echo "PASS: /etc/cron.hourly permissions are $PERMS (700 or more restrictive)"
    else
        echo "FAIL: /etc/cron.hourly permissions are $PERMS (should be 700 or more restrictive)"
        FAIL=1
    fi
else
    echo "INFO: /etc/cron.hourly does not exist"
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
