#!/bin/bash
# CIS Benchmark 1.7.7 - Ensure GDM disabling automatic mounting of removable media is not overridden
# Audit Script

audit_passed=true

echo "Checking GDM automatic mounting override configuration..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      This check is not applicable if GDM is not installed"
    echo ""
    echo "AUDIT RESULT: PASS - GDM is not installed (not applicable)"
    exit 0
fi

echo "GDM is installed, checking automatic mounting override settings..."

# Check dconf locks directory
locks_dir="/etc/dconf/db/local.d/locks"

echo ""
echo "Checking dconf locks configuration..."

# Settings to verify are locked
declare -A settings=(
    ["automount"]="/org/gnome/desktop/media-handling/automount"
    ["automount-open"]="/org/gnome/desktop/media-handling/automount-open"
)

# Check if locks directory exists
if [ -d "$locks_dir" ]; then
    echo "PASS: Locks directory exists at $locks_dir"
    
    # Check each setting
    for setting in "${!settings[@]}"; do
        lock_path="${settings[$setting]}"
        
        if grep -Psrilq -- "^\h*$lock_path\b" "$locks_dir"/* 2>/dev/null; then
            echo "PASS: \"$setting\" ($lock_path) is locked"
        else
            echo "FAIL: \"$setting\" ($lock_path) is not locked"
            audit_passed=false
        fi
    done
else
    echo "FAIL: Locks directory does not exist at $locks_dir"
    audit_passed=false
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - GDM automatic mounting settings cannot be overridden"
    exit 0
else
    echo "AUDIT RESULT: FAIL - GDM automatic mounting settings can be overridden by users"
    exit 1
fi
