#!/bin/bash

# CIS 1.2.1.1 - Ensure GPG keys are configured (Manual)
# This script checks for GPG keys in the apt trusted directories

echo "Checking GPG keys for package manager..."
echo ""

gpg_keys_found=0

# Check for GPG/ASC files in trusted.gpg.d and sources.list.d
for file in /etc/apt/trusted.gpg.d/*.{gpg,asc} /etc/apt/sources.list.d/*.{gpg,asc}; do
    if [ -f "$file" ]; then
        gpg_keys_found=1
        echo "File: $file"
        gpg --list-packets "$file" 2>/dev/null | awk '/keyid/ && !seen[$NF]++ {print "  keyid:", $NF}'
        gpg --list-packets "$file" 2>/dev/null | awk '/Signed-By:/ {print "  signed-by:", $NF}'
        echo ""
    fi
done

# Also check the deprecated apt-key list (for backwards compatibility)
if command -v apt-key >/dev/null 2>&1; then
    echo "Legacy apt-key list (deprecated):"
    apt-key list 2>/dev/null | grep -E "^pub|uid" || true
    echo ""
fi

if [ $gpg_keys_found -eq 0 ]; then
    echo "WARNING: No GPG keys found in /etc/apt/trusted.gpg.d/ or /etc/apt/sources.list.d/"
    echo "This requires MANUAL REVIEW to verify GPG keys are configured IAW site policy"
    exit 1
fi

echo "GPG keys found. MANUAL REVIEW REQUIRED to verify configuration IAW site policy."
exit 0
