#!/bin/bash

# CIS 5.4.2.5 - Ensure root path integrity
# Manual remediation script - identifies issues for correction

echo "Checking root's PATH for security issues..."

l_pmask="0022"
l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
l_root_path="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"

echo "Current root PATH: $l_root_path"
echo ""

issues_found=0

# Check for empty directory (::)
if grep -q "::" <<< "$l_root_path"; then
    echo "ISSUE: PATH contains empty directory (::)"
    echo "  ACTION: Remove empty entries from PATH in root's shell configuration"
    issues_found=1
fi

# Check for trailing colon (:)
if grep -Pq ":\h*$" <<< "$l_root_path"; then
    echo "ISSUE: PATH contains trailing colon (:)"
    echo "  ACTION: Remove trailing colon from PATH"
    issues_found=1
fi

# Check for current working directory (.)
if grep -Pq '(\h+|:)\.(:|\h*$)' <<< "$l_root_path"; then
    echo "ISSUE: PATH contains current working directory (.)"
    echo "  ACTION: Remove . from PATH"
    issues_found=1
fi

# Check each path component
unset a_path_loc && IFS=":" read -ra a_path_loc <<< "$l_root_path"
for l_path in "${a_path_loc[@]}"; do
    if [ -d "$l_path" ]; then
        l_fown=$(stat -Lc '%U' "$l_path")
        l_fmode=$(stat -Lc '%#a' "$l_path")
        
        if [ "$l_fown" != "root" ]; then
            echo "ISSUE: Directory \"$l_path\" is owned by \"$l_fown\""
            echo "  ACTION: chown root \"$l_path\""
            issues_found=1
        fi
        
        if [ $(( $l_fmode & $l_pmask )) -gt 0 ]; then
            echo "ISSUE: Directory \"$l_path\" has mode $l_fmode (should be $l_maxperm or more restrictive)"
            echo "  ACTION: chmod $l_maxperm \"$l_path\""
            issues_found=1
        fi
    else
        echo "ISSUE: \"$l_path\" is not a directory"
        echo "  ACTION: Remove from PATH or create the directory"
        issues_found=1
    fi
done

if [ $issues_found -eq 0 ]; then
    echo "SUCCESS: Root PATH is correctly configured"
else
    echo ""
    echo "Manual intervention required to fix the above issues"
    return 1
fi
