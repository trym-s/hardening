#!/bin/bash
# CIS 2.4.2.1 Ensure at is restricted to authorized users

echo "Checking at access restrictions..."

# First check if at is installed
if ! dpkg -l | grep -q "^ii.*\bat\b"; then
    echo "INFO: at is not installed - this control is not applicable"
    echo ""
    echo "AUDIT RESULT: PASS - Not applicable"
    exit 0
fi

FAIL=0

# Check if at.deny exists (it should NOT exist)
if [ -f /etc/at.deny ]; then
    echo "FAIL: /etc/at.deny exists (should be removed)"
    FAIL=1
else
    echo "PASS: /etc/at.deny does not exist"
fi

# Check if at.allow exists
if [ -f /etc/at.allow ]; then
    PERMS=$(stat -Lc "%a" /etc/at.allow)
    UID=$(stat -Lc "%u" /etc/at.allow)
    GID=$(stat -Lc "%g" /etc/at.allow)
    
    # Check ownership (should be root:root - UID 0, GID 0)
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ]; then
        echo "PASS: /etc/at.allow is owned by root:root"
    else
        echo "FAIL: /etc/at.allow is not owned by root:root (UID: $UID, GID: $GID)"
        FAIL=1
    fi
    
    # Check permissions (should be 640 or more restrictive)
    if [ "$PERMS" -le 640 ]; then
        echo "PASS: /etc/at.allow permissions are $PERMS (640 or more restrictive)"
    else
        echo "FAIL: /etc/at.allow permissions are $PERMS (should be 640 or more restrictive)"
        FAIL=1
    fi
else
    echo "FAIL: /etc/at.allow does not exist"
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
