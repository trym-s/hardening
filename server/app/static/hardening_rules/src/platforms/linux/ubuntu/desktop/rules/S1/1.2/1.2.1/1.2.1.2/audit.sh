#!/bin/bash

# CIS 1.2.1.2 - Ensure package manager repositories are configured (Manual)
# This script displays configured package repositories for manual verification

echo "Checking package manager repository configuration..."
echo ""
echo "==================================================================="
echo "Configured Package Repositories:"
echo "==================================================================="
echo ""

# Display apt repository configuration
if command -v apt-cache >/dev/null 2>&1; then
    apt-cache policy
    echo ""
else
    echo "ERROR: apt-cache command not found"
    exit 1
fi

echo "==================================================================="
echo "Repository Sources Files:"
echo "==================================================================="
echo ""

# Show sources.list
if [ -f /etc/apt/sources.list ]; then
    echo "File: /etc/apt/sources.list"
    grep -v "^#" /etc/apt/sources.list | grep -v "^$" || echo "  (no active entries)"
    echo ""
fi

# Show sources.list.d entries
if [ -d /etc/apt/sources.list.d ]; then
    echo "Additional repository files in /etc/apt/sources.list.d/:"
    for file in /etc/apt/sources.list.d/*.list; do
        if [ -f "$file" ]; then
            echo "  File: $file"
            grep -v "^#" "$file" | grep -v "^$" | sed 's/^/    /' || echo "    (no active entries)"
            echo ""
        fi
    done
fi

echo "==================================================================="
echo "MANUAL REVIEW REQUIRED"
echo "==================================================================="
echo ""
echo "Please verify that:"
echo "1. All repositories are official and trusted sources"
echo "2. Repositories are configured according to site policy"
echo "3. Security update repositories are enabled"
echo "4. No unauthorized or rogue repositories are present"
echo ""
echo "This check requires manual verification against site policy."
echo ""

# Exit with 0 as this is informational and requires manual review
exit 0
