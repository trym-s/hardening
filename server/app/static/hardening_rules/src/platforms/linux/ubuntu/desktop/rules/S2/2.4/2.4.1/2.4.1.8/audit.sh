#!/bin/bash
# CIS 2.4.1.8 Ensure crontab is restricted to authorized users

echo "Checking crontab access restrictions..."

FAIL=0

# Check if cron.deny exists (it should NOT exist)
if [ -f /etc/cron.deny ]; then
    echo "FAIL: /etc/cron.deny exists (should be removed)"
    FAIL=1
else
    echo "PASS: /etc/cron.deny does not exist"
fi

# Check if cron.allow exists
if [ -f /etc/cron.allow ]; then
    PERMS=$(stat -Lc "%a" /etc/cron.allow)
    UID=$(stat -Lc "%u" /etc/cron.allow)
    GID=$(stat -Lc "%g" /etc/cron.allow)
    
    # Check ownership (should be root:root - UID 0, GID 0)
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ]; then
        echo "PASS: /etc/cron.allow is owned by root:root"
    else
        echo "FAIL: /etc/cron.allow is not owned by root:root (UID: $UID, GID: $GID)"
        FAIL=1
    fi
    
    # Check permissions (should be 640 or more restrictive)
    if [ "$PERMS" -le 640 ]; then
        echo "PASS: /etc/cron.allow permissions are $PERMS (640 or more restrictive)"
    else
        echo "FAIL: /etc/cron.allow permissions are $PERMS (should be 640 or more restrictive)"
        FAIL=1
    fi
else
    echo "FAIL: /etc/cron.allow does not exist"
    FAIL=1
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
