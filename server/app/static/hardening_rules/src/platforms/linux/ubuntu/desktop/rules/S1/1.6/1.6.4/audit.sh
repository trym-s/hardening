#!/bin/bash
# CIS Benchmark 1.6.4 - Ensure access to /etc/motd is configured
# Audit Script

audit_passed=true

echo "Checking /etc/motd access configuration..."

motd_file="/etc/motd"

# Check if /etc/motd exists
if [ -e "$motd_file" ]; then
    echo "INFO: $motd_file exists"
    
    # Resolve symlinks
    real_file=$(readlink -e "$motd_file")
    
    # Get file permissions, owner, and group
    file_perms=$(stat -Lc '%a' "$real_file")
    file_uid=$(stat -Lc '%u' "$real_file")
    file_gid=$(stat -Lc '%g' "$real_file")
    
    echo "Current status:"
    stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' "$real_file"
    echo ""
    
    # Check ownership (should be root:root, uid=0, gid=0)
    if [ "$file_uid" -eq 0 ] && [ "$file_gid" -eq 0 ]; then
        echo "PASS: Owner and group are root (0:0)"
    else
        echo "FAIL: Owner ($file_uid) and/or group ($file_gid) are not root (0)"
        audit_passed=false
    fi
    
    # Check permissions (should be 644 or more restrictive)
    # 644 means: owner=rw (6), group=r (4), others=r (4)
    # More restrictive means:
    # - Owner: 0, 2, 4, or 6 (no execute bit, max rw)
    # - Group: 0 or 4 only (no write, no execute)
    # - Others: 0 or 4 only (no write, no execute)
    
    # Pad permissions to 3 digits
    padded_perms=$(printf "%03d" "$file_perms")
    
    # Extract individual permission digits
    owner_perm=${padded_perms:0:1}
    group_perm=${padded_perms:1:1}
    other_perm=${padded_perms:2:1}
    
    perm_ok=true
    perm_errors=""
    
    # Check owner permissions (should be 0, 2, 4, or 6 - no execute, max rw)
    case "$owner_perm" in
        0|2|4|6) ;;
        *) perm_ok=false; perm_errors="$perm_errors Owner has invalid permission ($owner_perm)." ;;
    esac
    
    # Check group permissions (should be 0 or 4 only - read or none)
    case "$group_perm" in
        0|4) ;;
        *) perm_ok=false; perm_errors="$perm_errors Group has invalid permission ($group_perm)." ;;
    esac
    
    # Check other permissions (should be 0 or 4 only - read or none)
    case "$other_perm" in
        0|4) ;;
        *) perm_ok=false; perm_errors="$perm_errors Others has invalid permission ($other_perm)." ;;
    esac
    
    if [ "$perm_ok" = true ]; then
        echo "PASS: Permissions ($file_perms) are 644 or more restrictive"
    else
        echo "FAIL: Permissions ($file_perms) are not compliant"
        echo "      Errors:$perm_errors"
        echo "      Expected: 644 or more restrictive (e.g., 644, 640, 600, 400, 444, 440, 404, 000)"
        audit_passed=false
    fi
else
    echo "INFO: $motd_file does not exist (this is acceptable)"
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - Access to /etc/motd is configured properly"
    exit 0
else
    echo "AUDIT RESULT: FAIL - Access to /etc/motd is not configured properly"
    exit 1
fi
