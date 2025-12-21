#!/bin/bash
# CIS Benchmark 1.6.4 - Ensure access to /etc/motd is configured
# Remediation Script

echo "Applying remediation for CIS 1.6.4 - Ensure access to /etc/motd is configured..."

motd_file="/etc/motd"

# Check if /etc/motd exists
if [ -e "$motd_file" ]; then
    # Resolve symlinks to get the real file
    real_file=$(readlink -e "$motd_file")
    
    if [ -n "$real_file" ]; then
        echo "Configuring access for $real_file..."
        
        # Set ownership to root:root
        echo "Setting ownership to root:root..."
        if chown root:root "$real_file"; then
            echo "Successfully set ownership to root:root"
        else
            echo "ERROR: Failed to set ownership"
            return 1
        fi
        
        # Set permissions to 644
        echo "Setting permissions to 644..."
        if chmod 644 "$real_file"; then
            echo "Successfully set permissions to 644"
        else
            echo "ERROR: Failed to set permissions"
            return 1
        fi
        
        # Display new status
        echo ""
        echo "New status:"
        stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' "$real_file"
    else
        echo "ERROR: Could not resolve $motd_file"
        return 1
    fi
else
    echo "INFO: $motd_file does not exist, no action needed"
fi

echo ""
echo "Remediation complete for CIS 1.6.4 - Ensure access to /etc/motd is configured"
