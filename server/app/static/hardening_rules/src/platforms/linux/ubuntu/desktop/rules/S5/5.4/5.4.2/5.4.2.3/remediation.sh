#!/bin/bash

# CIS 5.4.2.3 - Ensure group root is the only GID 0 group
# Ensure root group has GID 0

echo "Ensuring root group has GID 0..."

# Ensure root group has GID 0
groupmod -g 0 root 2>/dev/null

echo "Checking for non-root groups with GID 0..."

non_root_gid0=$(awk -F: '($1 != "root" && $3=="0"){print $1}' /etc/group)

if [ -z "$non_root_gid0" ]; then
    echo "SUCCESS: Only root group has GID 0"
    return 0
fi

echo "WARNING: The following non-root groups have GID 0:"
echo "$non_root_gid0"
echo ""
echo "Manual action required:"
echo "For each group listed above, run:"
echo "  groupmod -g <new_gid> <groupname>"
echo ""
return 1
