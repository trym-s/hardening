#!/bin/bash

# CIS 5.4.2.5 - Ensure root path integrity
# Audit root's PATH for security issues

echo "Checking root's PATH integrity..."

l_output2=""
l_pmask="0022"
l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
l_root_path="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"

# Parse PATH
unset a_path_loc && IFS=":" read -ra a_path_loc <<< "$l_root_path"

# Check for empty directory (::)
grep -q "::" <<< "$l_root_path" && l_output2="$l_output2\n - root's path contains an empty directory (::)"

# Check for trailing colon (:)
grep -Pq ":\h*$" <<< "$l_root_path" && l_output2="$l_output2\n - root's path contains a trailing (:)"

# Check for current working directory (.)
grep -Pq '(\h+|:)\.(:|\h*$)' <<< "$l_root_path" && l_output2="$l_output2\n - root's path contains current working directory (.)"

# Check each path component
while read -r l_path; do
    if [ -d "$l_path" ]; then
        while read -r l_fmode l_fown; do
            [ "$l_fown" != "root" ] && l_output2="$l_output2\n - Directory: \"$l_path\" is owned by: \"$l_fown\" should be owned by \"root\""
            [ $(( $l_fmode & $l_pmask )) -gt 0 ] && l_output2="$l_output2\n - Directory: \"$l_path\" is mode: \"$l_fmode\" and should be mode: \"$l_maxperm\" or more restrictive"
        done <<< "$(stat -Lc '%#a %U' "$l_path")"
    else
        l_output2="$l_output2\n - \"$l_path\" is not a directory"
    fi
done <<< "$(printf "%s\n" "${a_path_loc[@]}")"

if [ -z "$l_output2" ]; then
    echo "PASS: Root's path is correctly configured"
    exit 0
else
    echo "FAIL: Root's path has the following issues:"
    echo -e "$l_output2"
    exit 1
fi
