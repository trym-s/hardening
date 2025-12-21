#!/bin/bash
# CIS Benchmark 1.7.2 - Ensure GDM login banner is configured
# Remediation Script

echo "Applying remediation for CIS 1.7.2 - Ensure GDM login banner is configured..."

# Default banner message
BANNER_MESSAGE="Authorized uses only. All activity may be monitored and reported."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      No action needed - this rule is not applicable"
    return 0
fi

echo "GDM is installed, configuring login banner..."

# Create dconf profile for gdm
dconf_profile="/etc/dconf/profile/gdm"
echo "Creating/updating dconf profile at $dconf_profile..."

mkdir -p /etc/dconf/profile
cat > "$dconf_profile" << 'EOF'
user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults
EOF

echo "Created dconf profile"

# Create banner message configuration
banner_config_dir="/etc/dconf/db/gdm.d"
banner_config="$banner_config_dir/01-banner-message"

echo "Creating banner configuration at $banner_config..."

mkdir -p "$banner_config_dir"
cat > "$banner_config" << EOF
[org/gnome/login-screen]
banner-message-enable=true
banner-message-text='$BANNER_MESSAGE'
EOF

echo "Created banner configuration"

# Update dconf database
echo "Updating dconf database..."
if command -v dconf &>/dev/null; then
    dconf update
    echo "Successfully updated dconf database"
else
    echo "WARNING: dconf command not found, database not updated"
    echo "         Run 'dconf update' manually after installing dconf"
fi

echo ""
echo "Current configuration:"
echo "----------------------"
echo "dconf profile ($dconf_profile):"
cat "$dconf_profile"
echo ""
echo "Banner config ($banner_config):"
cat "$banner_config"
echo "----------------------"
echo ""
echo "Remediation complete for CIS 1.7.2 - Ensure GDM login banner is configured"
echo ""
echo "NOTE: Users must log out and back in again for the settings to take effect"
echo "      A system restart may be required for CIS-CAT Assessor to appropriately assess"
