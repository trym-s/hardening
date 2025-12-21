#!/bin/bash

# Remediate sshd access configuration
echo "Configuring sshd access control..."

# Check if already configured
if grep -qE '^\s*(AllowUsers|AllowGroups|DenyUsers|DenyGroups)\s+' /etc/ssh/sshd_config; then
    echo "INFO: SSH access control is already configured:"
    grep -E '^\s*(AllowUsers|AllowGroups|DenyUsers|DenyGroups)\s+' /etc/ssh/sshd_config
    echo ""
    echo "No changes made."
    return 0
fi

# Remove any commented directives
sed -i '/^#\s*AllowGroups/d' /etc/ssh/sshd_config

# Add AllowGroups sudo (recommended approach)
echo "AllowGroups sudo" >> /etc/ssh/sshd_config

# Reload sshd
systemctl reload sshd

echo "SUCCESS: SSH access configured for sudo group members"
echo "  AllowGroups sudo"
echo ""
echo "Note: Only users in the 'sudo' group can now access SSH."
echo "To add a user to sudo group: usermod -aG sudo <username>"
