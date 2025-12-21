#!/bin/bash
# CIS Benchmark 1.6.1 - Ensure message of the day is configured properly
# Remediation Script

echo "Applying remediation for CIS 1.6.1 - Ensure message of the day is configured properly..."

motd_file="/etc/motd"

# Check if /etc/motd exists
if [ -f "$motd_file" ]; then
    echo "Checking $motd_file for prohibited content..."
    
    # Get OS ID
    os_id=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | sed -e 's/"//g')
    
    # Remove escape sequences that display OS information
    echo "Removing OS information escape sequences..."
    
    # Create a temporary file with cleaned content
    sed -i 's/\\m//g; s/\\r//g; s/\\s//g; s/\\v//g' "$motd_file"
    
    # Remove OS name references (case insensitive)
    if [ -n "$os_id" ]; then
        sed -i "s/$os_id//gi" "$motd_file"
    fi
    
    echo "Cleaned $motd_file of prohibited content"
    
    # Check if file is now empty or contains only whitespace
    if [ ! -s "$motd_file" ] || ! grep -q '[^[:space:]]' "$motd_file"; then
        echo "INFO: $motd_file is empty after cleanup"
        echo "Consider adding an appropriate message of the day or removing the file"
    fi
else
    echo "INFO: $motd_file does not exist, no action needed"
fi

echo ""
echo "Remediation complete for CIS 1.6.1 - Ensure message of the day is configured properly"
echo ""
echo "NOTE: Please review /etc/motd and add appropriate content according to your site policy"
echo "The file should contain a legal warning banner without OS-specific information"
