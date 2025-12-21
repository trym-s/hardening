#!/bin/bash
# CIS Benchmark 1.7.9 - Ensure GDM autorun-never is not overridden
# Audit Script

audit_passed=true

echo "Checking GDM autorun-never override configuration..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      This check is not applicable if GDM is not installed"
    echo ""
    echo "AUDIT RESULT: PASS - GDM is not installed (not applicable)"
    exit 0
fi

echo "GDM is installed, checking autorun-never override settings..."

# Check dconf locks directory
locks_dir="/etc/dconf/db/local.d/locks"

echo ""
echo "Checking dconf locks configuration..."

# Setting to verify is locked
lock_path="/org/gnome/desktop/media-handling/autorun-never"

# Check if locks directory exists
if [ -d "$locks_dir" ]; then
    echo "PASS: Locks directory exists at $locks_dir"
    
    # Check if autorun-never is locked
    if grep -Psrilq -- "^\h*$lock_path\b" "$locks_dir"/* 2>/dev/null; then
        echo "PASS: autorun-never ($lock_path) is locked"
    else
        echo "FAIL: autorun-never ($lock_path) is not locked"
        audit_passed=false
    fi
else
    echo "FAIL: Locks directory does not exist at $locks_dir"
    audit_passed=false
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - GDM autorun-never setting cannot be overridden"
    exit 0
else
    echo "AUDIT RESULT: FAIL - GDM autorun-never setting can be overridden by users"
    exit 1
fi
