#!/bin/bash
# CIS 1.3.1.4 Audit - Level 2 (ENFORCE ONLY)

# Check if apparmor_status is available
if ! command -v apparmor_status >/dev/null 2>&1; then
    echo "FAIL: apparmor_status not found"
    exit 1
fi

# Check if AppArmor is running
if ! systemctl is-active --quiet apparmor 2>/dev/null; then
    echo "FAIL: AppArmor not running"
    exit 1
fi

fail=0

# Check profiles - MUST be enforce only (excluding snap profiles)
loaded=$(apparmor_status 2>/dev/null | grep "profiles are loaded" | awk '{print $1}' || echo "0")
enforce=$(apparmor_status 2>/dev/null | grep "profiles are in enforce mode" | awk '{print $1}' || echo "0")
complain=$(apparmor_status 2>/dev/null | grep "profiles are in complain mode" | awk '{print $1}' || echo "0")

# Count non-snap profiles in complain mode
non_snap_complain=0
if [[ "$complain" -gt 0 ]]; then
    non_snap_complain=$(apparmor_status 2>/dev/null | sed -n '/profiles are in complain mode/,/profiles are in enforce mode/p' | grep "^   " | grep -v "snap\." | wc -l || echo "0")
fi

if [[ "$loaded" -eq 0 ]]; then
    echo "FAIL: No profiles loaded"
    fail=1
elif [[ "$non_snap_complain" -gt 0 ]]; then
    echo "FAIL: $non_snap_complain non-snap profiles in complain mode (Level 2 requires enforce only)"
    fail=1
else
    echo "PASS: All non-snap profiles in enforce mode (Total: $loaded loaded, $complain snap profiles in complain mode - ignored)"
fi

# Check unconfined
unconfined=$(apparmor_status 2>/dev/null | grep "processes are unconfined but have a profile defined" | awk '{print $1}' || echo "0")

if [[ "$unconfined" -gt 0 ]]; then
    echo "FAIL: $unconfined unconfined processes"
    fail=1
else
    echo "PASS: No unconfined processes"
fi

if [[ $fail -eq 0 ]]; then
    echo "Level 2 PASS"
    exit 0
else
    echo "Level 2 FAIL"
    exit 1
fi