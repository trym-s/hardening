#!/bin/bash
# CIS Benchmark 1.7.3 - Ensure GDM disable-user-list option is enabled
# Remediation Script

echo "Applying remediation for CIS 1.7.3 - Ensure GDM disable-user-list option is enabled..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      No action needed - this rule is not applicable"
    return 0
fi

echo "GDM is installed, configuring disable-user-list..."

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

# Create login-screen configuration
login_screen_config_dir="/etc/dconf/db/gdm.d"
login_screen_config="$login_screen_config_dir/00-login-screen"

echo "Creating login-screen configuration at $login_screen_config..."

mkdir -p "$login_screen_config_dir"
cat > "$login_screen_config" << 'EOF'
[org/gnome/login-screen]
# Do not show the user list
disable-user-list=true
EOF

echo "Created login-screen configuration"

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
echo "Login screen config ($login_screen_config):"
cat "$login_screen_config"
echo "----------------------"
echo ""
echo "Remediation complete for CIS 1.7.3 - Ensure GDM disable-user-list option is enabled"
echo ""
echo "NOTE: Users must log out and back in again for the settings to take effect"
