#!/bin/bash
# CIS 1.3.1.3 Audit - Ensure all AppArmor Profiles are in enforce or complain mode

# Check if apparmor_status is available
if ! command -v apparmor_status >/dev/null 2>&1; then
    echo "ERROR: apparmor_status not found"
    exit 1
fi

# Check if AppArmor is running
if ! systemctl is-active --quiet apparmor 2>/dev/null; then
    echo "ERROR: AppArmor not running"
    exit 1
fi

fail=0

# Profile check
loaded=$(apparmor_status 2>/dev/null | grep "profiles are loaded" | awk '{print $1}' || echo "0")
if [[ "$loaded" -eq 0 ]]; then
    echo "FAIL: No profiles loaded"
    fail=1
else
    echo "PASS: $loaded profiles loaded"
fi

# Unconfined check
unconfined=$(apparmor_status 2>/dev/null | grep "processes are unconfined but have a profile defined" | awk '{print $1}' || echo "0")
if [[ "$unconfined" -gt 0 ]]; then
    echo "FAIL: $unconfined unconfined processes"
    fail=1
else
    echo "PASS: No unconfined processes"
fi

if [[ $fail -eq 0 ]]; then
    echo "AUDIT PASSED"
    exit 0
else
    echo "AUDIT FAILED"
    exit 1
fi