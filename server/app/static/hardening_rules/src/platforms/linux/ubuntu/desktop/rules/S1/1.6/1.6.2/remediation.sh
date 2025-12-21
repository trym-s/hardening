#!/bin/bash
# CIS Benchmark 1.6.2 - Ensure local login warning banner is configured properly
# Remediation Script

echo "Applying remediation for CIS 1.6.2 - Ensure local login warning banner is configured properly..."

issue_file="/etc/issue"

# Default warning banner message
default_banner="Authorized users only. All activity may be monitored and reported."

# Check if /etc/issue exists
if [ -f "$issue_file" ]; then
    echo "Checking $issue_file for prohibited content..."
    
    # Get OS ID
    os_id=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | sed -e 's/"//g')
    
    # Remove escape sequences that display OS information
    echo "Removing OS information escape sequences..."
    
    # Create cleaned content
    sed -i 's/\\m//g; s/\\r//g; s/\\s//g; s/\\v//g' "$issue_file"
    
    # Remove OS name references (case insensitive)
    if [ -n "$os_id" ]; then
        sed -i "s/$os_id//gi" "$issue_file"
    fi
    
    echo "Cleaned $issue_file of prohibited content"
    
    # Check if file is now empty or contains only whitespace
    if [ ! -s "$issue_file" ] || ! grep -q '[^[:space:]]' "$issue_file"; then
        echo "INFO: $issue_file is empty after cleanup, setting default banner"
        echo "$default_banner" > "$issue_file"
    fi
else
    echo "INFO: $issue_file does not exist, creating with default banner"
    echo "$default_banner" > "$issue_file"
fi

echo ""
echo "Current $issue_file contents:"
echo "----------------------------"
cat "$issue_file"
echo "----------------------------"
echo ""
echo "Remediation complete for CIS 1.6.2 - Ensure local login warning banner is configured properly"
echo ""
echo "NOTE: Please review /etc/issue and customize according to your site policy"
