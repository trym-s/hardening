#!/bin/bash
# CIS 2.4.1.2 Ensure permissions on /etc/crontab are configured

echo "Checking /etc/crontab permissions..."

FAIL=0

if [ -f /etc/crontab ]; then
    PERMS=$(stat -Lc "%a" /etc/crontab)
    UID=$(stat -Lc "%u" /etc/crontab)
    GID=$(stat -Lc "%g" /etc/crontab)
    
    # Check ownership (should be root:root - UID 0, GID 0)
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ]; then
        echo "PASS: /etc/crontab is owned by root:root"
    else
        echo "FAIL: /etc/crontab is not owned by root:root (UID: $UID, GID: $GID)"
        FAIL=1
    fi
    
    # Check permissions (should be 600 or more restrictive)
    if [ "$PERMS" -le 600 ]; then
        echo "PASS: /etc/crontab permissions are $PERMS (600 or more restrictive)"
    else
        echo "FAIL: /etc/crontab permissions are $PERMS (should be 600 or more restrictive)"
        FAIL=1
    fi
else
    echo "INFO: /etc/crontab does not exist"
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
