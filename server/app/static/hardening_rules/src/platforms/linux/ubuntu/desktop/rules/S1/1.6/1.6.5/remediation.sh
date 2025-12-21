#!/bin/bash
# CIS Benchmark 1.6.5 - Ensure access to /etc/issue is configured
# Remediation Script

echo "Applying remediation for CIS 1.6.5 - Ensure access to /etc/issue is configured..."

issue_file="/etc/issue"

# Check if /etc/issue exists
if [ -e "$issue_file" ]; then
    # Resolve symlinks to get the real file
    real_file=$(readlink -e "$issue_file")
    
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
        echo "ERROR: Could not resolve $issue_file"
        return 1
    fi
else
    echo "WARNING: $issue_file does not exist"
    echo "Consider creating it with an appropriate warning banner"
fi

echo ""
echo "Remediation complete for CIS 1.6.5 - Ensure access to /etc/issue is configured"
