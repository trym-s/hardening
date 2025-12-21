#!/bin/bash
# CIS Benchmark 1.7.1 - Ensure GDM is removed
# Remediation Script

echo "Applying remediation for CIS 1.7.1 - Ensure GDM is removed..."

# Check if gdm3 is installed
gdm_status=$(dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null)

if [ "$gdm_status" = "installed" ]; then
    echo "gdm3 is installed, removing..."
    
    echo ""
    echo "WARNING: This will remove the GNOME Display Manager and the graphical login interface."
    echo "         The system will no longer have a GUI login screen after this operation."
    echo ""
    
    # Purge gdm3 package
    echo "Purging gdm3 package..."
    if apt purge -y gdm3; then
        echo "Successfully purged gdm3"
    else
        echo "ERROR: Failed to purge gdm3"
        return 1
    fi
    
    # Remove unused dependencies
    echo "Removing unused dependencies..."
    apt autoremove -y || echo "WARNING: Failed to autoremove dependencies"
else
    echo "gdm3 is not installed, no action needed"
fi

echo ""
echo "Remediation complete for CIS 1.7.1 - Ensure GDM is removed"
