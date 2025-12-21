#!/bin/bash
# CIS Benchmark 1.5.4 - Ensure prelink is not installed
# Remediation Script

echo "Applying remediation for CIS 1.5.4 - Ensure prelink is not installed..."

# Check if prelink is installed
if dpkg-query -s prelink &>/dev/null; then
    echo "prelink is installed, removing..."
    
    # Restore binaries to normal before uninstalling
    echo "Restoring binaries to normal state..."
    if command -v prelink &>/dev/null; then
        if prelink -ua 2>/dev/null; then
            echo "Successfully restored binaries to normal"
        else
            echo "WARNING: Failed to restore binaries (prelink -ua)"
        fi
    fi
    
    # Uninstall prelink
    echo "Uninstalling prelink..."
    if apt purge -y prelink; then
        echo "Successfully removed prelink"
    else
        echo "ERROR: Failed to remove prelink"
        return 1
    fi
else
    echo "prelink is not installed, no action needed"
fi

echo ""
echo "Remediation complete for CIS 1.5.4 - Ensure prelink is not installed"
