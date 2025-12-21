#!/bin/bash
# CIS Benchmark 1.5.5 - Ensure Automatic Error Reporting is not enabled
# Remediation Script

echo "Applying remediation for CIS 1.5.5 - Ensure Automatic Error Reporting is not enabled..."

# Check if apport is installed
if dpkg-query -s apport &>/dev/null; then
    echo "apport is installed, disabling..."
    
    # Disable apport in /etc/default/apport
    apport_default="/etc/default/apport"
    if [ -f "$apport_default" ]; then
        echo "Configuring $apport_default..."
        if grep -Pq '^\h*enabled\h*=' "$apport_default"; then
            # Replace existing enabled line
            sed -i 's/^\s*enabled\s*=.*/enabled=0/' "$apport_default"
            echo "Updated enabled=0 in $apport_default"
        else
            # Add enabled=0 if not present
            echo "enabled=0" >> "$apport_default"
            echo "Added enabled=0 to $apport_default"
        fi
    else
        # Create the file with enabled=0
        echo "enabled=0" > "$apport_default"
        echo "Created $apport_default with enabled=0"
    fi
    
    # Stop and mask the apport service
    echo "Stopping apport service..."
    if systemctl stop apport.service 2>/dev/null; then
        echo "Successfully stopped apport.service"
    else
        echo "INFO: apport.service was not running or could not be stopped"
    fi
    
    echo "Masking apport service..."
    if systemctl mask apport.service 2>/dev/null; then
        echo "Successfully masked apport.service"
    else
        echo "WARNING: Failed to mask apport.service"
    fi
else
    echo "apport is not installed, no action needed"
fi

echo ""
echo "Remediation complete for CIS 1.5.5 - Ensure Automatic Error Reporting is not enabled"
