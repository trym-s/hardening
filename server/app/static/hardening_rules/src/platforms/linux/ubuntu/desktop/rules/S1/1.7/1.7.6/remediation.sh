#!/bin/bash
# CIS Benchmark 1.7.6 - Ensure GDM automatic mounting of removable media is disabled
# Remediation Script

echo "Applying remediation for CIS 1.7.6 - Ensure GDM automatic mounting of removable media is disabled..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      No action needed - this rule is not applicable"
    return 0
fi

echo "GDM is installed, configuring automatic mounting settings..."

# Ensure user profile exists
dconf_profile="/etc/dconf/profile/user"
if [ ! -f "$dconf_profile" ]; then
    echo "Creating dconf profile at $dconf_profile..."
    mkdir -p /etc/dconf/profile
    cat > "$dconf_profile" << 'EOF'
user-db:user
system-db:local
EOF
    echo "Created dconf profile"
else
    echo "dconf profile already exists at $dconf_profile"
fi

# Create automount configuration
automount_config_dir="/etc/dconf/db/local.d"
automount_config="$automount_config_dir/00-media-automount"

echo "Creating automount configuration at $automount_config..."

mkdir -p "$automount_config_dir"
cat > "$automount_config" << 'EOF'
[org/gnome/desktop/media-handling]
automount=false
automount-open=false
EOF

echo "Created automount configuration"

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
echo "Automount config ($automount_config):"
cat "$automount_config"
echo "----------------------"
echo ""
echo "Remediation complete for CIS 1.7.6 - Ensure GDM automatic mounting of removable media is disabled"
echo ""
echo "NOTE: Users must log out and back in again for the settings to take effect"
