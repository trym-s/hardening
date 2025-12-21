#!/bin/bash
# CIS Benchmark 1.7.8 - Ensure GDM autorun-never is enabled
# Remediation Script

echo "Applying remediation for CIS 1.7.8 - Ensure GDM autorun-never is enabled..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      No action needed - this rule is not applicable"
    return 0
fi

echo "GDM is installed, configuring autorun-never setting..."

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

# Create autorun configuration
autorun_config_dir="/etc/dconf/db/local.d"
autorun_config="$autorun_config_dir/00-media-autorun"

echo "Creating autorun configuration at $autorun_config..."

mkdir -p "$autorun_config_dir"
cat > "$autorun_config" << 'EOF'
[org/gnome/desktop/media-handling]
autorun-never=true
EOF

echo "Created autorun configuration"

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
echo "Autorun config ($autorun_config):"
cat "$autorun_config"
echo "----------------------"
echo ""
echo "Remediation complete for CIS 1.7.8 - Ensure GDM autorun-never is enabled"
echo ""
echo "NOTE: Users must log out and back in again for the settings to take effect"
